package core.jquery.plugins.modules
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
	
	public final class jQueryImageSlide extends jQueryPlugin
	{
		include '../../includes/RequirePlugin.as';
		public static const name:String = 'imageSlide';
		
		private var defaults:Object =
			{
				distance: 150,
				left:     null,
				right:    null,
				up:       null,
				down:     null,
				ease:     null
			};
		
		public function imageSlide(options:Object = null):jQuery
		{
			defaults = ObjectUtils.merge([defaults, options]);
			
			//self.target.addEventListener(MouseEvent.MOUSE_DOWN, startSwipe);
			
			return self;
		}
		
		
		
		override public function die():void
		{
		}
		
		
		private function calculate(e:MouseEvent):void
		{
		}
		
	}
}