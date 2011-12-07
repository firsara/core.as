package core.api.data
{
	import core.actions.log;
	import core.api.Config;
	import core.utils.NetUtils;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	
	public class FontHandler extends EventDispatcher
  {
		//include '../../_inc_/StaticRequire.as';
		//private static var         _instance :FontHandler;
		//public static function get instance():FontHandler { return _instance; }
		
		private var _fontLoader:Loader;
		private var _fontRequest:URLRequest;
		private var _queue:Array;
		private var _queueLength:int;
		
		
		public function FontHandler():void
		{
			//include '../../_inc_/StaticRequireValidation.as';
			//_instance = this;
			_queue = new Array();
		}
		
    public function get fonts():Array               { return _queue; }
		public function set fonts(fontQueue:Array):void { _queue = fontQueue; }
		
		public function get percentage():Number
		{
			var p:Number = _fontLoader.contentLoaderInfo.bytesLoaded / _fontLoader.contentLoaderInfo.bytesTotal;
			return ((_queue.length - 1 + p) / _queueLength);
		}
		
		
		public function load():void
    {
			_queueLength = _queue.length;
			loadFont();
		}
		
		
		private function loadFont():void
    {
			_fontRequest = new URLRequest( NetUtils.recache( String( _queue[0] ) ) );
			
			_fontLoader = new Loader();
			_fontLoader.contentLoaderInfo.addEventListener(Event.INIT, reportFont);
			_fontLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, notFound);
			_fontLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressFont);
			_fontLoader.load( _fontRequest );
		}
		
		
		// EVENTS
		private function reportFont(event:Event):void
    {
			dispatchEvent(event);
			removeEvents(event);
			_queue.shift();
			
			if (_queue.length == 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				if (Config.instance.debug) displayFonts();
			}
			else
			{
				loadFont();
			}
		}
		private function notFound(event:IOErrorEvent):void
    {
			removeEvents(event);
			dispatchEvent(event);
		}
		
		private function progressFont(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		
		private function removeEvents(targetEvent:Event):void
    {
			targetEvent.currentTarget.removeEventListener(Event.INIT, reportFont);
			targetEvent.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, notFound);
			targetEvent.currentTarget.removeEventListener(ProgressEvent.PROGRESS, progressFont);
		}
		
		private function displayFonts():void
    {
			var f:Array = Font.enumerateFonts();
			for each (var registeredFont:Font in f)
				core.actions.log("Registered Font ::\n" +
							  "\tname -> " + registeredFont.fontName + "\n" +
								"\ttype -> " + registeredFont.fontType + "\n" +
								"\tstyle -> " + registeredFont.fontStyle + "\n\n", this);
		}
	}
	
}
