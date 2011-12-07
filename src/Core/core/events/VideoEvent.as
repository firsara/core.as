package core.events
{
	import flash.events.Event;
	
	public dynamic class VideoEvent extends Event
	{
		public static const READY:String = "ready";
    public static const COMPLETE:String = "complete";
		
		public function VideoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
      super(type, bubbles, cancelable);
		}
		
	}
}
