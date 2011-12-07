package core.data
{
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	import com.adobe.images.PNGEncoder;
	
	import core.actions.dynamicFunctionCall;
	import core.actions.extractDefinitions;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLTableSchema;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	public class Database
	{
		private static const DEFAULT_MATCH_TYPE:String = DatabaseMatch.AND;
		private static const DISSALLOWED_CREATE_COLUMNS:Array = ['id', 'time', 'active'];
		private static const DISSALLOWED_UPDATE_COLUMNS:Array = ['id', 'time'];
		
		private var _ready:Boolean;
		private var _waitExecutement:Boolean;
		private var _forceExecutement:Boolean;
		
		private var _databaseFile:File;
		private var _connection:SQLConnection;
		private var _responder:DatabaseResponder;
		private var _keyGenerator:EncryptionKeyGenerator;
		
		private var _createNewDB:Boolean;
		
		private var _queuedStatements:Array;
		
		private var _wantToClearDatabase:Boolean;
		
		
		// PUBLIC METHODS
		
		public function connect  (toDatabase:String = 'data.db',
															password:String = '',
															onOpen:Function = null,
															onError:Function = null,
															onWrongPassword:Function = null,
															onWeakPassword:Function = null):void
		{
			if (onOpen != null)          _responder.open = onOpen;
			if (onError != null)         _responder.error = onError;
			if (onWrongPassword != null) _responder.wrongPassword = onWrongPassword;
			if (onWeakPassword != null)  _responder.weakPassword = onWeakPassword;
			
			connectToDatabase(toDatabase, password);
		}
		
		public function close():void { _connection.close(); }
		
		// SQL METHODS
		public function SELECT_WHERE     (fromTable:String, asClass:Class = null, match:* = null, matchType:String = DEFAULT_MATCH_TYPE, success:Function = null, failure:Function = null) :void { selectFrom(fromTable, asClass, match, matchType, success, failure); }
		public function SELECT           (fromTable:String, asClass:Class = null,                                  success:Function = null, failure:Function = null) :void { selectFrom(fromTable, asClass, null, DEFAULT_MATCH_TYPE, success, failure); }
		public function CREATE           (table:String, data:Object,                                               success:Function = null, failure:Function = null) :void { createTable(table, data, success, failure); }
		public function DROP             (table:String,                                                            success:Function = null, failure:Function = null) :void { dropTable(table, success, failure); }
		public function INSERT           (intoTable:String, data:Object,                                           success:Function = null, failure:Function = null) :void { insertInto(intoTable, data, success, failure); }
		public function UPDATE           (fromTable:String, id:int, data:Object,                                   success:Function = null, failure:Function = null) :void { updateFrom(fromTable, id, data, success, failure); }
		public function DELETE           (fromTable:String, match:* = null, matchType:String = DEFAULT_MATCH_TYPE, success:Function = null, failure:Function = null) :void { deleteFrom(fromTable, match, matchType, success, failure); }
		
		public function EXECUTE          (statement:String, asClass:Class = null,                                  success:Function = null, failure:Function = null) :void { executeStatement(statement, asClass, success, failure); }		
		
		public function reencrypt        (password:String = '')                                                                                         :void { reencryptDatabase(password); }
		
		public function clear():void
		{
			if (!_connection)
			{
				_wantToClearDatabase = true;
				return;
			}
			
			_waitExecutement = true;
			_connection.loadSchema(null, null, 'main', true, new Responder(loadSchemaHandler, noSchemaFound));
		}
		
		
		public function deleteDatabase(name:String = 'data.db'):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(name);
			if (file.exists) file.deleteFile();
		}
		
		
		
		
		// CONSTRUCTOR
		
		public function Database()
		{
			_connection = new SQLConnection();
			_responder = new DatabaseResponder();
			_keyGenerator = new EncryptionKeyGenerator();
			
			_queuedStatements = new Array();
		}
		
		
		
		
		
		private function connectToDatabase(name:String, password:String):void
		{
			if (name == '') name = 'data.db';
			
			var encryptionKey:ByteArray;
			
			if (password != '')
			{
				if (!_keyGenerator.validateStrongPassword(password))
				{
					_responder.weakPassword();
					return;
				}
				
				encryptionKey = _keyGenerator.getEncryptionKey(password);
			}
			
			_databaseFile = File.applicationStorageDirectory.resolvePath(name);
			_createNewDB = (_databaseFile.exists != true);
			
			trace( 'CONNECTING to Database  ' + _databaseFile.nativePath );
			
			_connection.addEventListener(SQLEvent.OPEN, openSuccess);
			_connection.addEventListener(SQLErrorEvent.ERROR, openError);
			
			_connection.openAsync(_databaseFile, SQLMode.CREATE, null, false, 1024, encryptionKey);
		}
		
		
		
		
		private function reencryptDatabase(password:String):void
		{
			_connection.reencrypt(_keyGenerator.getEncryptionKey(password));
		}
		
		
		
		private function createTable(name:String, data:Object, success:Function, failure:Function):void
		{
			var values:Array = new Array();
			var key:String;
			
			var accessors:Array = core.actions.extractDefinitions(data).memberProperties;
			var dataObject:Object = data;
			if (isClass(data)) dataObject = new data();
			
			for each (key in accessors)
			{
				try
				{
					if (DISSALLOWED_CREATE_COLUMNS.indexOf(key.toLowerCase()) == -1)
					{
						values.push(key + " " + getTypeFrom(dataObject[key]));
					}
				}
				catch(e:Error){}
			}
			
			for (key in data) values.push(key + " " + getObjectTypeFrom(data[key]));
			
			var statement:String = "";
			statement += "CREATE TABLE IF NOT EXISTS "+name+" (";
			statement += "id INTEGER PRIMARY KEY AUTOINCREMENT, ";
			statement += "time TEXT, ";
			statement += "active INTEGER, ";
			statement += values.join(', ');
			statement += ")";
			
			executeStatement(statement, null, success, failure);
		}
		
		
		private function dropTable(name:String, success:Function, failure:Function):void
		{
			executeStatement('DROP TABLE ' + name, null, success, failure);
		}
		
		
		private function insertInto(table:String, data:Object, success:Function, failure:Function):void
		{
			// NOTE CHECK WITH NO PARAM
			
			var paramData:Object = new Object();
			var insertData:Object = new Object();
			var keys:Array = new Array();
			var key:String;
			var value:*;
			
			var accessors:Array = core.actions.extractDefinitions(data).memberProperties;
			var dataObject:Object = data;
			if (isClass(data)) dataObject = new data();
			
			for (key in data)           paramData[key] = data[key];
			for each (key in accessors) paramData[key] = dataObject[key];
			
			for (key in paramData)
			{
				if (DISSALLOWED_CREATE_COLUMNS.indexOf(key.toLowerCase()) >= 0) continue;
				
				keys.push(key);
				value = paramData[key];
				
				if (value is Boolean) value = (value == true ? 1 : 0);
				
				if (value is Bitmap || value is BitmapData)
				{
					var image:Bitmap = (value is Bitmap ? value as Bitmap : (value is BitmapData ? new Bitmap(value as BitmapData) : new Bitmap()));
					value = ByteArray(PNGEncoder.encode(image.bitmapData));
				}
				
				insertData[key] = value;
			}
			
			if (keys.length == 0) return;
			
			var sql:DatabaseStatement = new DatabaseStatement();
			sql.sqlConnection = _connection;
			sql.text = "INSERT INTO " + table + "(time, active, "+keys.join(', ')+") VALUES (:time, :active, :"+keys.join(', :')+")";
			sql.success = success;
			sql.failure = failure;
			
			sql.parameters[':time'] = String(new Date().getTime());
			sql.parameters[':active'] = 1;
			for (key in insertData) sql.parameters[':' + key] = insertData[key];
			
			buildStatement(sql);
		}
		
		
		private function updateFrom(table:String, id:int, data:Object, success:Function, failure:Function):void
		{
			// NOTE CHECK WITH NO PARAM
			
			var paramData:Object = new Object();
			var updateData:Object = new Object();
			var keys:Array = new Array();
			var key:String;
			var value:*;
			
			var accessors:Array = core.actions.extractDefinitions(data).memberProperties;
			var dataObject:Object = data;
			if (isClass(data)) dataObject = new data();
			
			for (key in data)           paramData[key] = data[key];
			for each (key in accessors) paramData[key] = dataObject[key];
			
			for (key in paramData)
			{
				if (DISSALLOWED_UPDATE_COLUMNS.indexOf(key.toLowerCase()) >= 0) continue;
				
				value = paramData[key];
				
				if (value is Boolean) value = (value == true ? 1 : 0);
				
				if (value is Bitmap || value is BitmapData)
				{
					var image:Bitmap = (value is Bitmap ? value as Bitmap : (value is BitmapData ? new Bitmap(value as BitmapData) : new Bitmap()));
					value = ByteArray(PNGEncoder.encode(image.bitmapData));
				}
				
				if (value == null)
				{
					trace(key + '  is empty!');
					continue;
				}
				//if (value.toString().length == 0) continue;
				
				keys.push(key);
				updateData[key] = value;
			}
			
			if (keys.length == 0) return;
			
			var updatePairs:Array = new Array();
			for (key in updateData)
			{
				if (String(updateData[key]).indexOf(' ') >= 0) updateData[key] = '"' + String(updateData[key]) + '"';
				updatePairs.push(key+"=:" + key);
				//updatePairs.push(key + " = " + updateData[key]);
			}
			
			
			var sql:DatabaseStatement = new DatabaseStatement();
			sql.sqlConnection = _connection;
			sql.text = "UPDATE " + table + " SET " + updatePairs.join(", ") + " WHERE id = " + id;
			sql.success = success;
			sql.failure = failure;
			
			for (key in updateData) sql.parameters[':' + key] = updateData[key];
			
			buildStatement(sql);
			
		}
		
		
		private function deleteFrom(tableName:String, match:*, matchType:String, success:Function, failure:Function):void
		{
			var statement:String = "DELETE FROM " + tableName;
			statement += getConditional(match, matchType);
			executeStatement(statement, null, success, failure);
		}
		
		
		
		
		private function selectFrom(tableName:String, asClass:Class, match:*, matchType:String, success:Function, failure:Function):void
		{
			var statement:String = "SELECT * FROM " + tableName;
			statement += getConditional(match, matchType);
			executeStatement(statement, asClass, success, failure);
		}
		
		
		
		
		
		
		
		
		// RUNNING & BUILDING SQL STATEMENTS
		
		private function executeStatement(statement:String, asClass:Class, success:Function, failure:Function):void
		{
			var sql:DatabaseStatement = new DatabaseStatement();
			sql.sqlConnection = _connection;
			sql.text = statement;
			sql.success = success;
			sql.failure = failure;
			sql.itemClass = asClass;
			
			buildStatement(sql);
		}
		
		
		
		private function buildStatement(sql:DatabaseStatement):void
		{
			if (!_ready || _waitExecutement && !_forceExecutement)
			{
				_queuedStatements.push(sql);
			}
			else
			{
				run(sql);
			}
		}
		
		
		private function run(sql:DatabaseStatement):void
		{
			trace(sql.text);
			
			sql.addEventListener(SQLEvent.RESULT, sqlResult);
			sql.addEventListener(SQLErrorEvent.ERROR, sqlError);
			sql.execute(-1);
		}
		
		//-- RUNNING & BUILDING SQL STATEMENTS
		
		
		
		
		
		// GENERAL SQL UTILITY FUNCTIONS
		
		private function getConditional(match:*, matchType:String):String
		{
			var conditional:String = '';
			
			if (match)
			{
				conditional += " WHERE ";
				
				if (match is String) conditional += String(match);
				else
				{
					var key:String;
					for (key in match) conditional += key + " = '" + String(match[key]) + "' " + matchType;
					conditional = conditional.substring(0, conditional.lastIndexOf(matchType));
				}
			}
			
			return conditional;
		}
		
		
		// GET DATA TYPE FROM OBJECT
		
		private function getTypeFrom(dataType:Object):String
		{
			if (dataType is Number)  return DatabaseType.REAL;
			if (dataType is uint)    return DatabaseType.REAL;
			if (dataType is int)     return DatabaseType.INTEGER;
			if (dataType is String)  return DatabaseType.TEXT;
			if (dataType is Boolean) return DatabaseType.INTEGER;
			
			return DatabaseType.BLOB;
		}
		
		private function getObjectTypeFrom(dataType:*):String
		{
			var d:String = String(dataType);
			
			if (d.indexOf('Number') != -1)  return DatabaseType.REAL;
			if (d.indexOf('uint') != -1)    return DatabaseType.REAL;
			if (d.indexOf('int') != -1)     return DatabaseType.INTEGER;
			if (d.indexOf('String') != -1)  return DatabaseType.TEXT;
			if (d.indexOf('Boolean') != -1) return DatabaseType.INTEGER;
			
			return DatabaseType.BLOB;
		}
		
		
		
		private function runQueuedStatement():void
		{
			if (_waitExecutement) return;
			
			if (_queuedStatements.length > 0)
			{
				var queuedStatement:DatabaseStatement = DatabaseStatement(_queuedStatements[0]);
				run(queuedStatement);
				
				_queuedStatements.shift();
			}
		}
		
		
		
		
		
		
		
		//******************//
		//***** EVENTS *****//
		//******************//
		
		
		// DATABASE CONNECT
		
		private function openSuccess(e:SQLEvent):void
		{
			_connection.removeEventListener(SQLEvent.OPEN, openSuccess);
			_connection.removeEventListener(SQLErrorEvent.ERROR, openError);
			
			_ready = true;
			core.actions.dynamicFunctionCall(_responder.open, e);
			
			if (_wantToClearDatabase) clear();
			
			runQueuedStatement();
		}
		
		
		private function openError(e:SQLErrorEvent):void
		{
			_connection.removeEventListener(SQLEvent.OPEN, openSuccess);
			_connection.removeEventListener(SQLErrorEvent.ERROR, openError);
			
			core.actions.dynamicFunctionCall(_responder.error, e);
			
			if (e.error.errorID == 3125)
			{
				// cannot encrypt an unencrypted DB
				//this.dispatchEvent(new DatabaseEvent(DatabaseEvent.
			}
			
			if (!_createNewDB && e.error.errorID == EncryptionKeyGenerator.ENCRYPTED_DB_PASSWORD_ERROR_ID)
			{
				core.actions.dynamicFunctionCall(_responder.wrongPassword, e);
			}
		}
		
		//-- DATABASE CONNECT
		
		
		
		
		
		
		// CLEAR DATABASE
		
		private function databaseCleared():void
		{
			_connection.compact(new Responder(databaseCompactComplete, databaseCompactComplete));
		}
		
		private function databaseCompactComplete(e:* = null):void
		{
			_waitExecutement = false;
			runQueuedStatement();
		}
		
		
		private function loadSchemaHandler(srcSchema:SQLSchemaResult):void
		{
			var schema:SQLTableSchema;
			var count:int = srcSchema.tables.length;
			_forceExecutement = true;
			
			for each (schema in srcSchema.tables)
			{
				count--;
				if (count == 0)
					dropTable(schema.name, databaseCleared, databaseCleared);
				else dropTable(schema.name, null, null);
			}
			
			_forceExecutement = false;
		}
		
		
		private function noSchemaFound(e:SQLError):void
		{
			databaseCompactComplete();
		}
		
		//-- CLEAR DATABASE
		
		
		
		
		
		// SQL EXECUTEMENT
		
		private function sqlResult(e:SQLEvent):void
		{
			var sql:DatabaseStatement = DatabaseStatement(e.currentTarget);
			var result:SQLResult = sql.getResult();
			var dispatchResult:DatabaseResult = new DatabaseResult(result.data, result.rowsAffected, result.complete, result.lastInsertRowID);
			core.actions.dynamicFunctionCall(sql.success, dispatchResult);
			cleanSQL(sql);
			
			runQueuedStatement();
		}
		
		private function sqlError(e:SQLErrorEvent):void
		{
			var sql:DatabaseStatement = DatabaseStatement(e.currentTarget);
			core.actions.dynamicFunctionCall(sql.failure, e.error);
			cleanSQL(sql);
			
			runQueuedStatement();
		}
		
		private function cleanSQL(sql:DatabaseStatement):void
		{
			sql.removeEventListener(SQLEvent.RESULT, sqlResult);
			sql.removeEventListener(SQLErrorEvent.ERROR, sqlError);
		}
		
		//-- SQL EXECUTEMENT
		
		
	}
}






// INTERNALS

import flash.data.SQLStatement;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;

internal class DatabaseStatement extends SQLStatement
{
	private var _success             :Function;
	private var _failure             :Function;
	
	public function set success(value:Function) :void { _success = value; }
	public function get success()    :Function        { return _success; }
	
	public function set failure(value:Function) :void { _failure = value; }
	public function get failure()    :Function        { return _failure; }
	
	public function DatabaseStatement()
	{
		super();
	}
}

internal class DatabaseResponder
{
	public var open                 :Function = internalConnectionOpen;
	public var error                :Function = internalConnectionError;
	public var wrongPassword        :Function = internalWrongPassword;
	public var weakPassword         :Function = internalWeakPassword;
	
	private function internalConnectionOpen(event:SQLEvent):void
	{
		trace("Connected successfully to database");
	}
	
	private function internalConnectionError(e:SQLErrorEvent):void
	{
		trace("Error creating or opening database.");
	}
	
	private function internalWrongPassword(e:SQLErrorEvent):void
	{
		trace("Incorrect password!");
	}
	
	private function internalWeakPassword(e:SQLErrorEvent):void
	{
		trace("The password must be 8-32 characters long. It must contain at least one lowercase letter, at least one uppercase letter, and at least one number or symbol.");
	}
}
