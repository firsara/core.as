package core.media
{
	import core.actions.dynamicFunctionCall;
	import core.api.data.FontHandler;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.Font;

	public class Fonts extends EventDispatcher
	{
		private var _fontLoader:FontHandler;
		private var _success:Function;
		private var _failure:Function;
		private var _progress:Function;
		
		
		public static function get(data:* = null, successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null):Fonts
		{
			return new Fonts(data, successCallback, failureCallback, progressCallback);
		}
		
		
		public function get percentage():Number
		{
			return _fontLoader.percentage;
		}
		
		public function Fonts(data:* = null, successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null)
		{
			_success = successCallback;
			_failure = failureCallback;
			_progress = progressCallback;
			
			if (data is Class)
			{
				try
				{
					Font.registerFont(data as Class);
					
					var evtComplete:Event = new Event(Event.COMPLETE);
					core.actions.dynamicFunctionCall(_success, evtComplete);
					dispatchEvent(evtComplete);
				}
				catch(e:Error)
				{
					core.actions.dynamicFunctionCall(_failure, e);
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				}
			}
			else
			{
				_fontLoader = new FontHandler();
				_fontLoader.addEventListener(Event.COMPLETE, fontsLoaded);
				_fontLoader.addEventListener(IOErrorEvent.IO_ERROR, fontsNotFound);
				_fontLoader.addEventListener(ProgressEvent.PROGRESS, progressLoader);
				_fontLoader.fonts = ((data is Array) ? (data as Array) : [data]);
				_fontLoader.load();
			}
		}
		
		
		private function disposeFontLoader():void
		{
			_fontLoader.removeEventListener(Event.COMPLETE, fontsLoaded);
			_fontLoader.removeEventListener(IOErrorEvent.IO_ERROR, fontsNotFound);
			_fontLoader.removeEventListener(ProgressEvent.PROGRESS, progressLoader);
			_fontLoader = null;
		}
		
		private function fontsLoaded(e:Event):void
		{
			disposeFontLoader();
			core.actions.dynamicFunctionCall(_success, e);
			dispatchEvent(e);
		}
		
		private function fontsNotFound(e:IOErrorEvent):void
		{
			disposeFontLoader();
			core.actions.dynamicFunctionCall(_failure, e);
			dispatchEvent(e);
		}
		
		private function progressLoader(e:ProgressEvent):void
		{
			dispatchEvent(e);
			core.actions.dynamicFunctionCall(_progress, percentage);
		}
	}
}