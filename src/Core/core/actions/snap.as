package core.actions
{
	import flash.display.DisplayObject;

	public function snap(child:DisplayObject, snapX:Boolean = true, snapY:Boolean = true):void
	{
		if (snapX) child.x = Math.round(child.x);
		if (snapY) child.y = Math.round(child.y);
	}
}