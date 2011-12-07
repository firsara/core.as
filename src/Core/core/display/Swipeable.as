package core.display
{
	import core.events.SwipeEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	
	public dynamic class Swipeable extends Sprite
	{
		public function Swipeable()
		{
			super();
			this.cacheAsBitmap = true;
			this.cacheAsBitmapMatrix = new Matrix();
			
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipe);
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		
		private function swipe(event:*):void
		{
			if (event.offsetX > 0) dispatchEvent(new SwipeEvent(SwipeEvent.SWIPE_RIGHT));
			else if (event.offsetX < 0) dispatchEvent(new SwipeEvent(SwipeEvent.SWIPE_LEFT));
			
			if (event.offsetY > 0) dispatchEvent(new SwipeEvent(SwipeEvent.SWIPE_DOWN));
			else if (event.offsetY < 0) dispatchEvent(new SwipeEvent(SwipeEvent.SWIPE_UP));
		}
		
		
		
		private function dispose(event:Event):void
		{
			this.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, swipe);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
	}
}
