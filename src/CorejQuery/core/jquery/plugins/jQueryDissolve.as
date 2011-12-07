package core.jquery.plugins
{
	import core.animation.Tween;
	import core.fx.Pixelator;
	import core.jquery.plugins.abstract.jQueryPlugin;
	import core.utils.ObjectUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public final class jQueryDissolve extends jQueryPlugin
	{
		include '../includes/RequirePlugin.as';
		public static const name:String = 'dissolve';
		
		private var defaults:Object =
			{
				from: 0,
				to:   1,
				ease: null
			};
		
		
		private var _pixelator:Pixelator;
		
		public function dissolve(options:Object, duration:* = null, callback:Function = null):jQuery
		{
			defaults = ObjectUtils.merge([defaults, options]);
			defaults.duration = duration;
			
			if (defaults.ease == null && defaults.to < defaults.from) defaults.ease = Tween.EASE_IN;
			
			self.append({onComplete:startDissolve}, 0);
			self.delay(defaults.duration);
			if (callback != null) self.call(defaults.callback);
			
			return self;
		}
		
		
		
		override public function die():void
		{
			_pixelator = null;
		}
		
		
		
		private function startDissolve():void
		{
			_pixelator = new Pixelator(self.target, defaults.from);
			_pixelator.x = self.target.x;
			_pixelator.y = self.target.y;
			
			Tween.to(_pixelator, defaults.duration, {pixelation: defaults.to, ease: defaults.ease, onComplete: reswapChildren});
			
			self.addedToStage(swapChildren);
		}
		
		private function swapChildren():void
		{
			var parent:DisplayObjectContainer = (self.target.parent as DisplayObjectContainer);
			parent.addChild(_pixelator);
			self.target.visible = false;
		}
		
		private function reswapChildren():void
		{
			if (_pixelator && _pixelator.parent) _pixelator.parent.removeChild(_pixelator);
			if (self && self.target) self.target.visible = true;
		}
		
		
	}
}