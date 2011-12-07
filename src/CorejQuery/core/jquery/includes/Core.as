
import core.actions.dynamicFunctionCall;
import core.animation.Tween;
import core.jquery.jQuery;
import core.jquery.jQueryEvents;
import core.jquery.plugins.abstract.jQueryPlugin;

include 'Statics.as'; 


private var _target:*;
private var _easing:*;
private var _tween:Tween;
private var _plugs:Array;

protected var store:Object = {};

public function get target():* { return _target; }


private function queryEach(callback:* = null, item:* = null, index:int = -1, array:Array = null, parameters:Array = null):void
{
	if (item is Array)
	{
		for (var i:int = 0; i < _target.length; i++) queryEach(callback, item[i], i, _target as Array);
	}
	else
	{
		if ((callback is String) && (this[callback] != null))
		{
			var temporary:jQuery = jQuery.getInstance(item, _easing);
			temporary[callback]();
			if (temporary != this) temporary.call(die);
		}
		
		return;
		core.actions.dynamicFunctionCall(callback, item, index, array);
	}
}

public function each(callback:* = null, ...parameters):jQuery
{
	queryEach(callback, _target, -1, null, parameters);
	return this;
}
/*
public function each(callback:Function = null):jQuery
{
	queryEach(callback, _target);
	return this;
}
*/

public function die():void
{
	if (_tween) _tween.die();
	jQueryEvents.die(this, _target);
	
	for each (var plugin:jQueryPlugin in _plugs)
	{
		plugin.die();
		plugin = null;
	}
	
	_plugs = null;
	_tween = null;
	_target = null;
}



/**
 * jQuery Constructor
 * */

public function jQuery(target:*, ease:* = null)
{
	_target = target;
	_easing = ease;
	_tween = Tween.append(target, ease);
	_plugs = new Array();
	
	var plugin:jQueryPlugin;
	
	if (_plugins) for each (var Plugin:Class in _plugins)
	{
		plugin = new Plugin();
		plugin.self = this;
		this[Plugin['name']] = plugin[Plugin['name']];
		
		_plugs.push(plugin);
	}
}

