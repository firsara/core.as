import core.jquery.jQuery;
import core.jquery.jQueryTraversing;

import flash.display.Sprite;
import flash.events.Event;


/*   jQuery TRAVERSING functions          */
/*   CLASS: core.jquery.jQueryTraversing  */
/*----------------------------------------*/


public function find         (what:*):jQuery               { return jQueryTraversing.find(_target, what, true); }
public function findAll      (what:*):jQuery               { return jQueryTraversing.find(_target, what, false); }

public function wrap         (object:Sprite = null):jQuery { jQueryTraversing.wrap(_target, object); return this; }
public function unwrap       ():jQuery                     { jQueryTraversing.unwrap(_target); return this; }

public function remove       ():jQuery                     { _tween.call(removeFromParent); return this; }
private function removeFromParent():void
{
	if (_target.parent) _target.parent.removeChild(_target);
}
