package core.jquery.plugins
{
	import core.animation.Tween;
	import core.jquery.jQuery;
	import core.jquery.plugins.abstract.jQueryPlugin;
	import core.utils.ObjectUtils;
	
	import flash.utils.setTimeout;
	
	public class jQueryWiggle extends jQueryPlugin
	{
		include '../includes/RequirePlugin.as';
		public static const name:String = 'wiggle';
		
		private var defaults:Object =
			{
				from: 0,
				to:   1,
				ease: null
			};
		
		private var accessor:String;
		
		public function wiggle(param:String, options:Object, duration:* = null):jQuery
		{
			defaults = ObjectUtils.merge([defaults, options]);
			defaults.param = param;
			defaults.duration = duration;
			
			accessor = 'jQueryWiggle' + param + 'Active';
			
			self[accessor] = true;
			self.append({onComplete:wiggleParam}, 0);
			
			return self;
		}
		
		
		override public function die():void
		{
			self[accessor] = false;
		}
		
		
		
		private function wiggleParam():void
		{
			if (self[accessor] != true) return;
			
			var randomParam:Number = Math.random() * (defaults.to - defaults.from) + defaults.from;
			var options:Object = {};
			options[defaults.param] = randomParam;
			options.ease = defaults.ease;
			
			self.append(options, defaults.duration);
			setTimeout(wiggleParam, defaults.duration * 1000);
		}
		
	}
}