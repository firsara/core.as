package core.display
{
	import core.Core;
	import core.utils.GraphicsUtils;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class Background
	{
		private static var _color1:uint;
		private static var _color2:uint;
		private static var _rotation:uint;
		private static var _stage:Stage;
		private static var _currentTarget:Sprite;
		
		public static function draw(target:Sprite, color1:uint, color2:uint, rotation:Number):void
		{
			if (_stage) _stage.removeEventListener(Event.RESIZE, resizeStage);
			
			_currentTarget = target;
			_color1 = color1;
			_color2 = color2;
			_rotation = rotation;
			
			if (target.stage) initDrawing();
			else target.addEventListener(Event.ADDED_TO_STAGE, initDrawing);
		}
		
		private static function initDrawing(e:Event = null):void
		{
			if (e) e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, initDrawing);
			
			_stage = _currentTarget.stage;
			_stage.addEventListener(Event.RESIZE, resizeStage);
			
			redrawGraphics();
		}
		
		private static function resizeStage(e:Event):void
		{
			redrawGraphics();
		}
		
		private static function redrawGraphics():void
		{
			var target:Sprite = ((_stage.getChildAt(0) || _currentTarget) as Sprite);
			target.graphics.clear();
			GraphicsUtils.drawLinearGradient(target.graphics, 0, 0, _stage.stageWidth, _stage.stageHeight, _color1, 1, _color2, 1, _rotation);
		}
	}
}