package core.media
{
	import core.actions.dynamicFunctionCall;
	import core.api.data.XMLHandler;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	public class XMLDoc extends EventDispatcher
	{
		private var _xml:XML;
		private var _xmlLoader:XMLHandler;
		private var _success:Function;
		private var _failure:Function;
		private var _progress:Function;
		private var _passData:Boolean;
		
		
		public static function get(data:* = null, successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null):XMLDoc
		{
			return new XMLDoc(data, successCallback, failureCallback, progressCallback, true);
		}
		
		public function get percentage():Number
		{
			return (_xmlLoader.percentage);
		}
		
		
		public function get xml():XML { return _xml; }
		public function set xml(value:XML):void
		{
			_xml = value;
			
			var e:Event = new Event(Event.COMPLETE);
			dispatchEvent(e);
			
			if (_passData) core.actions.dynamicFunctionCall(_success, _xml);
			else           core.actions.dynamicFunctionCall(_success, e);
		}
		
		
		public function XMLDoc(data:* = null, successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null, passData:Boolean = false)
		{
			_success = successCallback;
			_failure = failureCallback;
			_progress = progressCallback;
			_passData = passData;
			
			if (data is XML || data is XMLList)
			{
				xml = new XML(data);
			}
			else
			{
				_xmlLoader = new XMLHandler();
				_xmlLoader.addEventListener(Event.COMPLETE, parseData);
				_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, notFound);
				_xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressLoader);
				_xmlLoader.load(String(data));
			}
		}
		
		
		private function disposeXMLLoader():void
		{
			_xmlLoader.removeEventListener(Event.COMPLETE, parseData);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, notFound);
			_xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressLoader);
			_xmlLoader = null;
		}
		
		private function parseData(e:Event):void
		{
			xml = _xmlLoader.data;
			dispatchEvent(e);
			disposeXMLLoader();
		}
		
		private function notFound(e:IOErrorEvent):void
		{
			disposeXMLLoader();
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