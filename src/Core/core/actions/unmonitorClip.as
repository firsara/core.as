package core.actions
{
  import core.display.MonitorClip;
  
  import flash.display.DisplayObject;
  
	public function unmonitorClip(target:DisplayObject):void
	{
	  MonitorClip.unmonitor(target);
  }
}