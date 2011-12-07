package core.events
{
	import flash.events.Event;
	
	public dynamic class MoveEvent extends Event
	{
		public static const MOVE_COMPLETE:String = "moveComplete";
		public static const POSITION_UPDATE:String = "positionUpdate";
		public static const STOPPED_DRAG:String = "stoppedDrag";
		
		public function MoveEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}
