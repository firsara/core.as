package core.api.data
{
	import core.actions.log;
	import core.api.Config;
	import core.utils.NetUtils;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class AssetHandler extends EventDispatcher
  {
		include '../../_inc_/StaticRequire.as';
		private static var         _instance :AssetHandler;
		public static function get instance():AssetHandler { return _instance; }
		
		
		public static function get(className:String, ...parameters):*
		{
			return instance.get(className, parameters);
		}
		
		public static function reference(className:String):*
		{
			return instance.reference(className);
		}
		
		
		
		
		
		private var _assets:Array;
		private var _loading:Array;
		private var _path:String;
		private var _data:Loader;
		
		
		// CONSTRUCTION
		
		public function AssetHandler()
		{
			include '../../_inc_/StaticRequireValidation.as';
			
			_instance = this;
			_assets = new Array();
			_loading = new Array();
		}
		
		public function add(paths:Array):void
		{
			_loading = paths;
		}
		
		
		// Public functions
		public function load():void
		{
			loadNext();
		}
		
		
		
		
		
		
		// Returns a new Object
		public function get(className:String, ...Parameters):*
		{
			var asset:*;
			
			for (var i:Number = 0; i < _assets.length; i++)
			{
				asset = getFrom.apply(null, [_assets[i].path, className].concat(Parameters));
				if (asset != null) break;
			}
			
			if (asset) return asset;
			if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  Class  > " + className + " <  not found");
			return null;
		}
		
		
		//Returns a Reference to the Class
		public function reference(className:String):Class
		{
			var asset:Class;
			
			for (var i:Number = 0; i < _assets.length; i++)
				if ((asset = referenceFrom(_assets[i].path, className)))
					break;
			
			if (asset) return asset;
			if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  Class  > " + className + " <  not found");
			return null;
		}
		//---------------






		private function referenceFrom(path:String, className:String):Class
		{
			var assetInstance:Object;
			for (var i:Number = 0; i < _assets.length; i++)
				if (_assets[i].path == path)
					assetInstance = _assets[i];
			
			if (Config.instance.debug && !assetInstance) core.actions.log("core.data.AssetHandler ->  Undefined Asset File  > " + path);
			if (!assetInstance) return null;
			
			if (assetInstance.data.contentLoaderInfo.applicationDomain.hasDefinition(className))
			{
				if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  " + className + " Referenced from  >>  " + path);
				return Class( assetInstance.data.contentLoaderInfo.applicationDomain.getDefinition(className) );
			}
			
			if (Config.instance.debug) throw new Error("core.data.AssetHandler ->  Class  > " + className + " <  not found in File  > " + path + " <");
			return null;
		}
		
		private function getFrom(path:String, className:String, ...Parameters):*
		{
			if (Parameters.length > 10) throw new Error("No more than 10 Constructor Parameters supportet");
			
			var assetInstance:Object;
			var tempAsset:Object;
			for each (tempAsset in _assets)
			{
				if (tempAsset.path == path) assetInstance = tempAsset;
			}
			
			if (Config.instance.debug && !assetInstance) core.actions.log("core.data.AssetHandler ->  Undefined Asset File  > " + path);
			if (!assetInstance) return null;
			
			if (assetInstance.data.contentLoaderInfo.applicationDomain.hasDefinition(className))
			{
				if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  " + className + " Fetched from  >>  " + path);
				
				var asset:Class = Class( assetInstance.data.contentLoaderInfo.applicationDomain.getDefinition(className) );
				
				switch (Parameters.length)
				{
					case 10: return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4], Parameters[5], Parameters[6], Parameters[7], Parameters[8], Parameters[9]); break;
					case 9:  return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4], Parameters[5], Parameters[6], Parameters[7], Parameters[8]); break;
					case 8:  return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4], Parameters[5], Parameters[6], Parameters[7]); break;
					case 7:  return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4], Parameters[5], Parameters[6]);	break;
					case 6:  return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4], Parameters[5]); break;
					case 5:  return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4]); break;
					case 4:  return new asset(Parameters[0], Parameters[1], Parameters[2], Parameters[3]); break;
					case 3:  return new asset(Parameters[0], Parameters[1], Parameters[2]); break;
					case 2:  return new asset(Parameters[0], Parameters[1]); break;
					case 1:  return new asset(Parameters[0]); break;
					case 0:
					default:
					
					return new asset();
				}
				
				return new asset();
				
			}
			
			return null;
		}
		
		
		public function clear(from:int = 0, to:int = int.MAX_VALUE):void {
			if (to == int.MAX_VALUE) to = _assets.length;
			
			for (var i:int = from; i < to; i++)
			{
				NetUtils.unload(Loader(_assets[i].data));
				_assets[i].data = null;
			}
			
			_assets.splice(from, to - from);
		}
		//---------------
		
		
		
		
		
		private function loadNext():void {
			_data = new Loader();
			
			var counter:int = _assets.length;
			var assetObject:Object = {};
			assetObject.path = _loading[counter];
			assetObject.data = _data;
			
			_assets[counter] = assetObject;
			_assets[counter].data.contentLoaderInfo.addEventListener(Event.COMPLETE, assetComplete);
			_assets[counter].data.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, assetNotFound);
			_assets[counter].data.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, assetNotAllowed);
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			_path = _assets[counter].path;
			_assets[counter].data.load(new URLRequest(NetUtils.recache(_path)), context);
			
			if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  Loading assets from  >>  " + _path);
		}
		
		private function reportAsset(target:LoaderInfo):void
		{
			dispose(target);
			_loading.shift();
			
			if (_loading.length > 0)
			{
				loadNext();
			}
			else
			{
				dispatchEvent( new Event(Event.COMPLETE) );
			}
    }
		
		
		
		// Event Handler
    private function assetComplete(event:Event):void
		{
			reportAsset(LoaderInfo(event.currentTarget));
    	if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  assets Loaded from  >>  " + _path);
		}
		
    private function assetNotFound(event:IOErrorEvent):void
		{
			reportAsset(LoaderInfo(event.currentTarget));
    	if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  File  > " + _path + " <  not found");
    }

    private function assetNotAllowed(event:SecurityErrorEvent):void
		{
			reportAsset(LoaderInfo(event.currentTarget));
    	if (Config.instance.debug) core.actions.log("core.data.AssetHandler ->  Security error " + event);
    }
		//---------------
		
		
		// DISPOSE
		private function dispose(target:LoaderInfo):void
		{
			target.removeEventListener(Event.COMPLETE, assetComplete);
			target.removeEventListener(IOErrorEvent.IO_ERROR, assetNotFound);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, assetNotAllowed);
		}
		
	}
}
