import core.jquery.jQuery;

/*   jQuery ANIMATION functions   */
/*   CLASS: core.animation.Tween  */
/*--------------------------------*/

public function stop():jQuery { _tween.stop(); return this; }

public function delay        (duration:* = null, easing:* = null):jQuery            { _tween.delay(duration, easing); return this; }

public function slideUp      (duration:* = null, easing:* = null):jQuery            { _tween.slideUp(duration, easing); return this; }
public function slideDown    (duration:* = null, easing:* = null):jQuery            { _tween.slideDown(duration, easing); return this; }
public function slideRight   (duration:* = null, easing:* = null):jQuery            { _tween.slideRight(duration, easing); return this; }
public function slideLeft    (duration:* = null, easing:* = null):jQuery            { _tween.slideLeft(duration, easing); return this; }

// Fading Functions
public function fadeIn       (duration:* = null, easing:* = null):jQuery            { _tween.fadeIn(duration, easing); return this; }
public function fadeOut      (duration:* = null, easing:* = null):jQuery            { (_target is Array ? each('fadeOut', duration, easing) : _tween.fadeOut(duration, easing)); return this; }
public function fade         (to:Number, duration:* = null, easing:* = null):jQuery { _tween.fade(to, duration, easing); return this; }
public function hide         (duration:* = null, easing:* = null):jQuery            { _tween.hide(duration, easing); return this; }
public function show         (duration:* = null, easing:* = null):jQuery            { _tween.show(duration, easing); return this; }

public function toggle       (duration:* = null, easing:* = null):jQuery            { _tween.toggle(duration, easing); return this; }
public function slideToggle  (duration:* = null, easing:* = null):jQuery            { _tween.slideToggle(duration, easing); return this; }
public function slideToggleX (duration:* = null, easing:* = null):jQuery            { _tween.slideToggleX(duration, easing); return this; }

// APPEND OR INSERT NEW ANIMATION
public function append       (parameters:Object, duration:* = null):jQuery          { _tween.append(parameters, duration); return this; }
public function insert       (parameters:Object, duration:* = null):jQuery          { _tween.insert(parameters, duration); return this; }

// FUNCTION CALLBACK
public function call         (callback:Function, param:* = null):jQuery
{
	if (param == null) _tween.call(callback);
	else if (param is Array) _tween.call(callback, param);
	else _tween.call(callback, [param]); 
	return this;
}
