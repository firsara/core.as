package core.api.data
{
	import core.actions.dynamicFunctionCall;
	import core.utils.NetUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLHandler extends EventDispatcher
  {
		private var _xmlLoader:URLLoader;
		private var _xmlRequest:URLRequest;
		private var _data:XML;
		
		private var _success:Function;
		private var _failure:Function;
		private var _progress:Function;
		
		
		public function get data():XML
		{
			return _data;
		}
		
		public function get percentage():Number
		{
			return (_xmlLoader.bytesLoaded / _xmlLoader.bytesTotal);
		}
		
		
		public function XMLHandler(path:String = "", successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null)
		{
			if (path == "") return;
			
			if (successCallback != null) _success = successCallback;
			if (failureCallback != null) _failure = failureCallback;
			if (progressCallback != null) _progress = progressCallback;
      
			load(path);
		}
		
		public function load(path:String):void {
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			
			_xmlRequest = new URLRequest(NetUtils.recache(path));
			
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, parseData);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, notFound);
			_xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressLoad);
			_xmlLoader.load(_xmlRequest);
		}
		
		
		
		// EVENTS
		private function parseData(event:Event):void
		{
			_data = new XML(event.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
			
			core.actions.dynamicFunctionCall(_success, event);
			disposeLoader();
		}
		
		private function notFound(event:IOErrorEvent):void
		{
			dispatchEvent(event);
			
			core.actions.dynamicFunctionCall(_failure, event);
			disposeLoader();
		}
		
		
		private function progressLoad(event:ProgressEvent):void
		{
			dispatchEvent(event);
			core.actions.dynamicFunctionCall(_progress, percentage);
		}
		
		
		private function disposeLoader():void
		{
			_xmlLoader.removeEventListener(Event.COMPLETE, parseData);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, notFound);
			_xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressLoad);
			_xmlLoader = null;
			_xmlRequest = null;
		}

	}
	
}
