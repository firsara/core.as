package core.api.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class DataHandler extends EventDispatcher
	{
		private var _queue:Array;
		private var _data:Dictionary;
		
		public function get data():Array { return data; }
		
		public function append(name:String, LoaderType:Class, path:String):void
		{
			_queue.push({name: name, loader: new LoaderType(), path: path});
		}
		
		
		public function load():void
		{
			if (_queue.length == 0) dispatchEvent(new Event(Event.COMPLETE));
			else
			{
				_queue[0].loader.addEventListener(Event.COMPLETE, itemLoaded);
				_queue[0].loader.load(_queue[0].path);
			}
		}
		
		private function itemLoaded(e:Event):void
		{
			_queue[0].loader.removeEventListener(Event.COMPLETE, itemLoaded);
			_data[_queue[0].name] = _queue[0].loader;
			_queue.shift();
			load();
		}
		
		
		public function DataHandler()
		{
			_queue = new Array();
			_data = new Dictionary();
		}
	}
}