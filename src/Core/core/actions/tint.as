package core.actions
{
	import core.animation.tweenlite.TweenMax;
	import core.animation.tweenlite.plugins.ColorMatrixFilterPlugin;
	import core.animation.tweenlite.plugins.TweenPlugin;
	
	public function tint(object:*, value:uint):*
	{
		if (value == 0) return;
		
		TweenPlugin.activate([ColorMatrixFilterPlugin]);
		TweenMax.to(object, 0, {colorMatrixFilter:{colorize:value}});
		
		return object;
	}
	
	/*
	public function tint ( target : DisplayObject , color : uint ) : void
	{
		var rgb:RGBColor = new RGBColor( color );
		target.transform.colorTransform = new ColorTransform( 0 , 0 , 0 , 1 , rgb.r , rgb.g , rgb.b , 0 );
	}
	*/
}




/**
 * Apply a solid color to a black gradient.
 * @param target The DisplayObject to tint.
 * @param color The haxadecimal color to apply to object.
 */
//		public static function tintBlack ( target : DisplayObject , color : uint ) : void
//		{
//			var rgb : RGBColor = new RGBColor( color );

//			target.transform.colorTransform = new ColorTransform( 1 , 1 , 1 , 1 , rgb.r , rgb.g , rgb.b , 0 );
//		}

/**
 * Apply a solid color to a white gradient.
 * @param target The DisplayObject to tint.
 * @param color The haxadecimal color to apply to object.
 */
//		public static function tintWhite ( target : DisplayObject , color : uint ) : void
//		{
//			var rgb : RGBColor = new RGBColor( color );

//			target.transform.colorTransform = new ColorTransform( rgb.r / 255 , rgb.g / 255 , rgb.b / 255 , 1 , 0 , 0 , 0 , 0 );
//		}

