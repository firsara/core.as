package core.events
{
	import flash.events.Event;
	
	public dynamic class LocationEvent extends Event
	{
    public static const LOCATION_CHANGE:String = "locationChange";
    public static const QUERY_CHANGE:String = "queryChange";
		
		private var _url:String;
		
		public function LocationEvent(type:String, url:String = '', bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_url = url;
		}
		
		public function get url():String
		{
			return _url;
		}
		
	}
}
