
import core.animation.Tween;
import core.jquery.jQuery;

private static var _plugins:Array;
private static var _instances:Array;

public static function getInstance(obj:*, ease:*):jQuery
{
	var instance:jQuery;
	
	if (!_instances) _instances = new Array();
	for each (instance in _instances) if (instance == obj || instance.target == obj) return instance;
	
	instance = new jQuery(obj, ease);
	_instances.push(instance);
	
	return instance;
}

/*
public static function extend(functionName:*, functionCallback:Function):void
{
if (!_plugins) _plugins = new Array();
_plugins.push({name: functionName, callback: functionCallback});
}
*/

public static function extend(plugin:Class):void
{
	trace('Extendig jQuery with plugin: ' + plugin);
	
	if (!_plugins) _plugins = new Array();
	_plugins.push(plugin);
}

