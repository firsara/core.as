package core.events
{
	import flash.events.Event;
	
	public dynamic class CoreEvent extends Event
	{
		public static const CORE_READY:String = "coreReady";
		public static const UI_READY  :String = "uiReady";
		
		public function CoreEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}
