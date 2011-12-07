package core.ui
{
	import core.Core;
	import core.actions.dynamicFunctionCall;
	import core.api.Lib;
	import core.events.CoreEvent;
	import core.text.Style;
	import core.ui.assets.UIAssets;
	import core.ui.events.UIEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.utils.ByteArray;
	
	public class UI extends EventDispatcher 
	{
		static private var _color:uint;
		static public function get color():uint { return _color; }
		static public function set color(value:uint):void
		{
			_color = value;
			_instance.dispatchEvent(new UIEvent(UIEvent.CHANGE_DEFINITIONS));
		}
		
		static private var _instance  :UI;
		static private var _singleton :Boolean;
    static private var _ready     :Boolean;
		private var _callback:Function;
		
		public static function get ready():Boolean { return _ready; }
		public static function get instance():UI { return _instance; }
		
		public static function init(mainReference:*, callback:Function = null):UI
		{
			_singleton = true;
			return new UI(mainReference, callback);
		}
		
		
		public function UI(mainReference:*, callback:Function = null)
		{
			if(_instance) throw new Error('UI already initialized');
			if(!_singleton) throw new Error('UI can only be initialized via  >  UI.init  <');
			if (!Core.ready) Core.init(mainReference);
			
			if (!UIAssets.ready) UIAssets.init();
			
			_instance = this;
			_callback = callback;
			
			Lib.init();
			
			if (Lib.ready) dispatch();
			else Lib.dispatcher.addEventListener(Event.INIT, dispatch);
		}
		
		private function dispatch(event:Event = null):void
		{
			if (event) Lib.dispatcher.removeEventListener(Event.INIT, dispatch);
			core.actions.dynamicFunctionCall(_callback, event);
      
      _ready = true;
			dispatchEvent(new CoreEvent(CoreEvent.UI_READY));
		}
		
	}
}
