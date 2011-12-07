package core.jquery.plugins
{
	import core.actions.dynamicFunctionCall;
	import core.api.def.stage;
	import core.fx.Pixelator;
	import core.jquery.plugins.abstract.jQueryPlugin;
	import core.jquery.plugins.vars.jQuerySwipeVars;
	import core.utils.ObjectUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public final class jQuerySwipe extends jQueryPlugin
	{
		include '../includes/RequirePlugin.as';
		public static const name:String = 'swipe';
		
		private var defaults:Object =
			{
				distance: 150,
				left:     null,
				right:    null,
				up:       null,
				down:     null,
				ease:     null
			};
		
		private var _store:Point = new Point();
		private var _difference:Point = new Point();
		
		public function swipe(options:Object = null):jQuery
		{
			defaults = ObjectUtils.merge([defaults, options]);
			
			self.target.addEventListener(MouseEvent.MOUSE_DOWN, startSwipe);
			
			return self;
		}
		
		
		
		override public function die():void
		{
			_store = null;
			_difference = null;
			stopCalculation();
			self.target.removeEventListener(MouseEvent.MOUSE_DOWN, calculate);
		}
		
		
		private function calculate(e:MouseEvent):void
		{
			_difference.x = (e.stageX - _store.x);
			_difference.y = (e.stageY - _store.y);
			
			if (Math.abs(_difference.x) >= defaults.distance) swiped();
			if (Math.abs(_difference.y) >= defaults.distance) swiped();
		}
		
		
		
		private function swiped():void
		{
			stopSwipe();
			
			if      (_difference.x < 0 && defaults.left != null) core.actions.dynamicFunctionCall(defaults.left, self.target);
			else if (_difference.x > 0 && defaults.right != null) core.actions.dynamicFunctionCall(defaults.right, self.target);
			
			if      (_difference.y < 0 && defaults.up != null) core.actions.dynamicFunctionCall(defaults.up, self.target);
			else if (_difference.y > 0 && defaults.down != null) core.actions.dynamicFunctionCall(defaults.down, self.target);
		}
		
		
		
		private function startSwipe(e:MouseEvent):void
		{
			_store.x = e.stageX;
			_store.y = e.stageY;
			
			stopCalculation();
			core.api.def.stage.addEventListener(MouseEvent.MOUSE_MOVE, calculate);
			core.api.def.stage.addEventListener(MouseEvent.MOUSE_UP, stopCalculation);
		}
		
		private function stopCalculation(e:MouseEvent = null):void
		{
			core.api.def.stage.removeEventListener(MouseEvent.MOUSE_MOVE, calculate);
			core.api.def.stage.removeEventListener(MouseEvent.MOUSE_UP, stopCalculation);
		}
		
		private function stopSwipe():void
		{
			stopCalculation();
		}
		
	}
}