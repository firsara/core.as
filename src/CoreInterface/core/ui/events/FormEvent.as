package core.ui.events
{
	import flash.events.Event;

	public class FormEvent extends Event
	{
		public static const SUBMIT:String = 'submit';
		
		public function FormEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}