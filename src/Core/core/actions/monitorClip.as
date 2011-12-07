package core.actions
{
  import core.display.MonitorClip;
  
  import flash.display.DisplayObject;

  public function monitorClip(target:DisplayObject,
															moveCallback:Function = null,
															resizeCallback:Function = null,
															displayListChangeCallback:Function = null):void
  {
    MonitorClip.monitor(target, moveCallback, resizeCallback, displayListChangeCallback);
  }
}