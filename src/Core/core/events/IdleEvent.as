package core.events
{
	import flash.events.Event;
	
	public dynamic class IdleEvent extends Event
	{
		public static const USER_IDLE:String = "userIdle";
		public static const USER_ACTIVE:String = "userActive";
		
		private var _status:String;
		
		public function IdleEvent(type:String, status:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
			super(type, bubbles, cancelable);
			_status = status;
		}
		
		public function get status():String
    {
			return _status;
		}		
		
	}
}
