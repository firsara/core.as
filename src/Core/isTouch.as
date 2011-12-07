package
{
	import flash.events.Event;

	public function isTouch(event:Event):Boolean
	{
		return (event.type.toLowerCase().indexOf('touch') >= 0);
	}
}