﻿// TODO: Rename? -> Initializer ? create new DataHandler that handles array of any datapackage core.api.app{	import core.api.data.AssetHandler;	import core.api.data.FontHandler;	import core.api.data.XMLHandler;	import core.text.Style;		import flash.events.Event;	import flash.events.EventDispatcher;	import flash.utils.Dictionary;
		public class DataHandler extends EventDispatcher  {		static public const LOADING_FONTS:String  = "Initializer.LOADING_FONTS";		static public const LOADING_STYLES:String = "Initializer.LOADING_STYLES";		static public const LOADING_ASSETS:String = "Initializer.LOADING_ASSETS";		static public const LOADING_DATA:String   = "Initializer.LOADING_DATA";				private var _fonts:String;		private var _styles:String;		private var _assets:Array;		private var _data:Dictionary;				private var _store:Object;		private var _dataLoader:Array;				public function get fonts():String { return _fonts; }		public function set fonts(value:String):void		{			_fonts = value;		}				public function get styles():String { return _styles; }		public function set styles(value:String):void		{			_styles = value;		}				public function get assets():Array { return _assets; }		public function set assets(value:Array):void		{			_assets = value;		}				public function get percentage():Number		{			var p:Number = Number(_store.loaded / _store.count);			if(isNaN(p)) p = 0;			else if (String(p).toLowerCase() == "infinity") p = 1;			return p;		}				public function get status():String {			return String(_store.status);		}						public function DataHandler()		{			// CONSTRUCTUR			_fonts = "";			_styles = "";						_assets = new Array();			_store = new Object();						_data = new Dictionary();			_dataLoader = new Array();		}				public function add(dataPath:String, dataKey:String = ""):void		{			if (dataKey == "") dataKey = uniqueID;			_dataLoader.push({path:dataPath, key:dataKey});		}				public function load():void		{			for (var dataKey:String in _data) {				_dataLoader.push({path: _data[dataKey]});			}						_store.count = 2 + _assets.length + _dataLoader.length;			_store.loaded = 0;			_store.status = '';						loadFonts();		}						private function loadFonts():void		{			_store.status = LOADING_FONTS;						if (_fonts == "") {				loadStyles();				return;			}						// FONTS			var fontLoader:FontHandler = new FontHandler();			fontLoader.addEventListener(Event.COMPLETE, reportFonts);			fontLoader.fonts = [_fonts];			fontLoader.load();		}				private function loadStyles():void		{			_store.status = LOADING_STYLES;			_store.loaded++;						if (_styles == "") {				loadAssets();				return;			}						// STYLES			var styleLoader:XMLHandler = new XMLHandler();			styleLoader.addEventListener(Event.COMPLETE, reportStyles);			styleLoader.load(_styles);		}				private function loadAssets():void		{			_store.status = LOADING_ASSETS;			_store.loaded++;						if (_assets.length == 0) {				loadData();				return;			}						// ASSETS			AssetHandler.instance.add(_assets);			AssetHandler.instance.addEventListener(Event.COMPLETE, reportAssets);			AssetHandler.instance.load();		}				private function loadData(id:int = 0):void		{			if (id == 0)			{				_store.status = LOADING_DATA;				_store.loaded += _assets.length;			}						if (id >= _dataLoader.length) {				reportReady();				return;			}						function reportData(event:Event):void			{				_store.loaded++;				XMLHandler(event.currentTarget).removeEventListener(Event.COMPLETE, reportData);				_data[_dataLoader[id].key] = new XML(XMLHandler(event.currentTarget).data);				loadData(id + 1);			}						// DATA			_dataLoader[id].data = new XMLHandler();			_dataLoader[id].data.addEventListener(Event.COMPLETE, reportData);			_dataLoader[id].data.load(_dataLoader[id].path);		}				private function reportReady():void		{			dispatchEvent(new Event(Event.COMPLETE) );		}								private function get uniqueID():String		{			var id:int;			var counter:int;			var valid:Boolean = false;						while (!valid) {				id = (Math.random() * int.MAX_VALUE);				valid = true;				for (counter = 0; counter < _dataLoader.length; counter++) if (_dataLoader[counter].key == String(id)) valid = false;			}						return String(id);		}								// EVENTS				private function reportFonts(event:Event):void		{			event.currentTarget.removeEventListener(Event.COMPLETE, reportFonts);			loadStyles();		}				private function reportStyles(event:Event):void		{			event.currentTarget.removeEventListener(Event.COMPLETE, reportStyles);			Style.extend(new XML(XMLHandler(event.currentTarget).data));			loadAssets();		}				private function reportAssets(event:Event):void		{			event.currentTarget.removeEventListener(Event.COMPLETE, reportAssets);			loadData();		}					}	}