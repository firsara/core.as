private static var _required:Boolean;

public static function require():*
{
	var requiredInstance:* = new prototype.constructor();
	
	trace('Require ' + prototype.constructor);
	
	_required = true;
	return requiredInstance;
}
