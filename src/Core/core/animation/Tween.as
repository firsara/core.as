package core.animation
{
	import core.animation.tweenlite.OverwriteManager;
	import core.animation.tweenlite.TimelineMax;
	import core.animation.tweenlite.TweenMax;
	import core.animation.tweenlite.plugins.AutoAlphaPlugin;
	import core.animation.tweenlite.plugins.ColorMatrixFilterPlugin;
	import core.animation.tweenlite.plugins.TweenPlugin;
	import core.settings.TweenSetup;
	
	import flash.display.Sprite;
	
	public class Tween
  {
		public static const SLOW:String        = "slow";
		public static const NORMAL:String      = "normal";
		public static const FAST:String        = "fast";
		
		public static const EASE_IN_OUT:String = "easeInOut";
		public static const EASE_IN:String     = "easeIn";
		public static const EASE_OUT:String    = "easeOut";
		public static const EASE_NONE:String    = "easeNone";
		
		private static const DEFAULT:* = null;
		
		private static const MIN_VALUE:Number = 0.002;
		private static const MASK_NAME:String = "$AnimationMask";
		private static const APPEND:String = "$TYPE.APPEND";
		private static const INSERT:String = "$TYPE.INSERT";
		
		private static var $instances:Array;
		
		private var target:*;
		private var targetMask:Sprite;
		private var timeline:TimelineMax;
		private var lastTime:Number;
		private var type:String;
		private var easing:*;
		
		
		public static function start  (obj:*, easing:* = DEFAULT):Tween { return getTimelineFrom(obj, true, APPEND, easing); }
		public static function append (obj:*, easing:* = DEFAULT):Tween { return getTimelineFrom(obj, false, APPEND, easing); }
		public static function insert (obj:*, easing:* = DEFAULT):Tween { return getTimelineFrom(obj, false, INSERT, easing); }
		public static function stop   (obj:*):Tween                     { return getTimelineFrom(obj, true, APPEND, DEFAULT); }
		
		public static function to(obj:*, duration:* = NORMAL, parameters:Object = null):Tween {
			parameters = ( parameters  || {} );
			
			var anim:Tween = getTimelineFrom(obj, true, APPEND);
			anim.addTween(obj, duration, parameters);
			
			return anim;
		}
		
		
		public function stop():Tween { return Tween.stop(target); }
		
		public function delay      (duration:* = NORMAL, easing:* = DEFAULT):Tween { return addTween(target, duration, {ease:easing}); }
		public function fadeIn     (duration:* = NORMAL, easing:* = DEFAULT):Tween { return addTween(target, duration, {autoAlpha: 1, ease:easing}); }
		public function fadeOut    (duration:* = NORMAL, easing:* = DEFAULT):Tween { return addTween(target, duration, {autoAlpha: 0, ease:easing}); }
		public function slideUp    (duration:* = NORMAL, easing:* = DEFAULT):Tween { createMask(); return addTween(targetMask, duration, {scaleY: 0, ease:easing}); }
		public function slideDown  (duration:* = NORMAL, easing:* = DEFAULT):Tween { createMask(); return addTween(targetMask, duration, {scaleY: 1, ease:easing}); }
		public function slideRight (duration:* = NORMAL, easing:* = DEFAULT):Tween { createMask(); return addTween(targetMask, duration, {scaleX: 1, ease:easing}); }
		public function slideLeft  (duration:* = NORMAL, easing:* = DEFAULT):Tween { createMask(); return addTween(targetMask, duration, {scaleX: 0, ease:easing}); }
		
		public function fade(to:Number, duration:* = NORMAL, easing:* = DEFAULT):Tween { return addTween(target, duration, {autoAlpha: to, ease:easing}); }
		
		public function hide(duration:* = NORMAL, easing:* = DEFAULT):Tween {
			createMask();
			timeline.appendMultiple([
				new TweenMax(targetMask, convert(duration), {scaleX: 0, scaleY: 0, ease:easing}),
				new TweenMax(target, convert(duration), {autoAlpha: 0, ease:easing})
			]);
			return this;
		}
		
		public function show(duration:* = NORMAL, easing:* = DEFAULT):Tween {
			createMask();
			timeline.appendMultiple([
				new TweenMax(targetMask, convert(duration), {scaleX: 1, scaleY: 1, ease:convertEase(easing)}),
				new TweenMax(target, convert(duration), {autoAlpha: 1, ease:convertEase(easing)})
			]);
			return this;
		}
		
		public function toggle(duration:* = NORMAL, easing:* = DEFAULT):Tween {
			if (target.alpha < 0.5)
			     return show(duration, easing);
			else return hide(duration, easing);
		}
		
		public function slideToggle(duration:* = NORMAL, easing:* = DEFAULT):Tween {
			createMask();
			
			if (targetMask.scaleY < 0.5)
			     return slideDown(duration, easing);
			else return slideUp(duration, easing);
		}
		
		public function slideToggleX(duration:* = NORMAL, easing:* = DEFAULT):Tween {
			createMask();
			
			if (targetMask.scaleX < 0.5)
			     return slideRight(duration, easing);
			else return slideLeft(duration, easing);
		}
		
		public function append(parameters:Object, duration:* = NORMAL):Tween { return addTween(target, duration, parameters); }
		public function insert(parameters:Object, duration:* = NORMAL):Tween { return addTween(target, duration, parameters); }
		
		public function call(callback:Function, param:* = null):Tween {
			if (param == null)
			{
				return addTween(target, 0, {onComplete: callback});
			}
			else
			{
				if (!(param is Array)) param = [param];
				return addTween(target, 0, {onComplete: callback, onCompleteParams: param});
			}
		}
		
		
		
		
		
		public function die():void
		{
			removeTimelineFrom(target);
			killTweensOf(this);
			
			target = null;
			targetMask = null;
			timeline = null;
			type = null;
			easing = null;
		}
		
		
		
		// CONSTRUCTION
		
		private function init():void {
			$instances = new Array();
			OverwriteManager.mode = OverwriteManager.AUTO;
			TweenPlugin.activate([AutoAlphaPlugin, ColorMatrixFilterPlugin]);
		}
		
		public function Tween(obj:*, killTweens:Boolean = true):void {
			if ($instances == null) init();
			
			target = obj;
			createTimeline(this);
			
			if (killTweens) {
				removeTimelineFrom(target);
				killTweensOf(this);
			}
			$instances.push(this);
		}
		
		
		
		
		private function createMask():void {
			if (target.mask) { targetMask = Sprite(target.mask); return; }
			if ((targetMask = Sprite(target.getChildByName(MASK_NAME))) != null) return;
			
			targetMask = new Sprite();
			targetMask.name = MASK_NAME;
			targetMask.graphics.beginFill(0xFF0000, 1);
			targetMask.graphics.drawRect(0,0, target.width, target.height);
			targetMask.graphics.endFill();
			
			addMask();
		}
		
		private function addMask():void {
			target.addChild(targetMask);
			target.mask = targetMask;
		}
		
		private function removeMask():void {
			if (target.getChildByName(MASK_NAME)) target.removeChild(target.getChildByName(MASK_NAME));
		}
		
		
		
		private function addTween(target:*, duration:*, parameters:Object):Tween {
			if(parameters.ease == DEFAULT) parameters.ease = easing;
			if(parameters.ease) parameters.ease = convertEase(parameters.ease);
			duration = convert(duration);
			
			if (isNaN(lastTime) == false)
			{
				lastTime = MIN_VALUE;
				duration = Math.max(MIN_VALUE, duration);
				timeline.append(new TweenMax(target, MIN_VALUE, {delay: MIN_VALUE}));
			}
			
			lastTime = duration;
			if (type == INSERT)
			     timeline.insert(new TweenMax(target, duration, parameters));
			else timeline.append(new TweenMax(target, duration, parameters));
			
			// NOTE check if others area affected
			timeline.play();
			
			return this;
		}
		
		private function convertEase(easing:*):*
		{
			switch(String(easing).toUpperCase())
			{
				case String(DEFAULT).toUpperCase(): return TweenSetup.tweenEaseDefault;
				case EASE_IN_OUT.toUpperCase():     return TweenSetup.tweenEaseInOut;
				case EASE_IN.toUpperCase():         return TweenSetup.tweenEaseIn;
				case EASE_OUT.toUpperCase():        return TweenSetup.tweenEaseOut;
				case EASE_NONE.toUpperCase():       return TweenSetup.tweenEaseNone;
			}
			
			return easing;
		}
		
		private function convert(duration:*):Number
		{
			switch(String(duration).toUpperCase())
			{
				case SLOW.toUpperCase():   return TweenSetup.tweenSpeedSlow;
				case NORMAL.toUpperCase(): return TweenSetup.tweenSpeedNormal;
				case FAST.toUpperCase():   return TweenSetup.tweenSpeedFast;
			}
			
			if (String(Number(duration)) != String(duration)) return TweenSetup.tweenSpeedNormal;
			return Number(duration);
		}
		
		
		
		private static function killTweensOf(anim:Tween, killTimeline:Boolean = true):void {
			TweenMax.killTweensOf(anim.target);
			TweenMax.to(anim.target, 0, {overwrite: OverwriteManager.ALL_IMMEDIATE});
			
			if (killTimeline) 
			{
				removeTimelineFrom(anim.target);
				createTimeline(anim);
			}
		}
		
		private static function createTimeline(anim:Tween):void {
			var timelineVars:Object = {};
			timelineVars.onComplete = removeTimelineFrom;
			timelineVars.onCompleteParams = [anim.target];
			
			anim.timeline = new TimelineMax(timelineVars);
		}
		
		private static function removeTimelineFrom(obj:*):void {
			var tempInstances:Array = new Array();
			
			for each (var anim:Tween in $instances)
			{
				if (anim.target != obj) tempInstances.push(anim);
				else anim.timeline.stop();
			}
			
			$instances = tempInstances;
		}
		
		private static function getTimelineFrom(obj:*, killTimeline:Boolean = false, tweenType:String = APPEND, easing:* = DEFAULT):Tween {
			if (easing == DEFAULT) easing = TweenSetup.tweenEaseDefault;
			if (killTimeline) removeTimelineFrom(obj);
			
			var anim:Tween;
			
			if ($instances)
			for each (anim in $instances)
			{
				if (anim.target == obj)
				{
					anim.lastTime = NaN;
					anim.delay(MIN_VALUE);
					anim.type = tweenType;
					anim.easing = easing;
					
					return anim;
				}
			}
			
			anim = new Tween(obj, false);
			anim.type = tweenType;
			anim.easing = easing;
			
			return anim;
		}
		
	}
}
