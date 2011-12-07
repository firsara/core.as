package core.api
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class Lib
	{
		Lib.init();
		
		private static var _eventDispatcher:EventDispatcher;
		private static var _assets:Dictionary;
		private static var _calledInit:Boolean = false;
		private static var _ready:Boolean;
		
		
		public static function get dispatcher():EventDispatcher { return _eventDispatcher; }
		public static function get ready()     :Boolean         { return _ready; }
		
    
    public static function getNew(ClassName:Class, assignName:String = ''):DisplayObject
    {
      var temp:DisplayObject = (new ClassName() as DisplayObject);
      if (assignName != '') temp.name = assignName;
      return temp;
    }
		
		
		public static function get(asset:String, assignName:String = ""):DisplayObject
		{
			var Reference:Class = (_assets[asset] ? _assets[asset] : null);
			var object:*;
			
			if (Reference == null)
			{
				throw new Error(asset + ' not found in Lib');
				object = new Sprite();
			}
			else
			{
				object = new Reference();
			}
			
			try {
				object = new Bitmap(object);
				object.smoothing = true;
			} catch(e:Error){}
			
			if (assignName != "") object.name = assignName;
			
			return (object as DisplayObject);
		}
		
    
    // extend lib with display classes
    public static function extend(assets:Dictionary):void
    {
      var key:String;
      for (key in assets)
      {
        if (!_assets[key]) _assets[key] = assets[key];
      }
    }
    
    public static function add(asset:Class, key:String, replaceOldAsset:Boolean = false):void
    {
      if (!_assets[key] || replaceOldAsset) _assets[key] = asset;
    }
    
		
		public static function init():void
		{
			if (_calledInit) { return; }
			
			_eventDispatcher = new EventDispatcher();
			_calledInit = true;
			
			_assets = new Dictionary();
			
			_ready = true;
			_eventDispatcher.dispatchEvent(new Event(Event.INIT));
		}
		
		
	}
}

