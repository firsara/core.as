package core.events
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class EventHandler extends EventDispatcher
	{
		include '../../core/_inc_/StaticEventHandler.as';
		
		private static var _instance:EventHandler;
		
		public function EventHandler()
		{
			super();
			_instance = this;
		}
		
	}
}
