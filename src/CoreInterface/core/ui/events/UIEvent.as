package core.ui.events
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		public static const CHANGE_DEFINITIONS:String = 'changeDefinitions';
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}