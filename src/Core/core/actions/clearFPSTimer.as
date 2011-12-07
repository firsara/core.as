package core.actions
{
	import flash.utils.clearInterval;
	
	public function clearFPSTimer(id:uint):void
	{
		clearInterval(id);
	}
}
