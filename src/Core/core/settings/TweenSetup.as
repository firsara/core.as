package core.settings
{
	import core.animation.tweenlite.easing.Linear;
	import core.animation.tweenlite.easing.Quint;
	
	[ExcludeClass]
	public final class TweenSetup
	{
		// core.animation.Tween
		static public const tweenSpeedSlow         :Number = 0.85;
		static public const tweenSpeedNormal       :Number = 0.38;
		static public const tweenSpeedFast         :Number = 0.2;
		
		static public const tweenEaseDefault       :* = Quint.easeOut;
		static public const tweenEaseInOut         :* = Quint.easeInOut;
		static public const tweenEaseOut           :* = Quint.easeOut;
		static public const tweenEaseIn            :* = Quint.easeIn;
		static public const tweenEaseNone          :* = Linear.easeNone;
	}
}