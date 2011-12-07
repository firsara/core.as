import flash.events.EventDispatcher;

static private var _staticEventDispatcher:EventDispatcher;

public static function addEventListener(type:String, callback:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
	if (!_staticEventDispatcher) _staticEventDispatcher = new EventDispatcher();
	_staticEventDispatcher.addEventListener(type, callback, useCapture, priority, useWeakReference);
}
public static function removeEventListener(type:String, callback:Function, useCapture:Boolean = false):void {
	if (!_staticEventDispatcher) _staticEventDispatcher = new EventDispatcher();
	_staticEventDispatcher.removeEventListener(type, callback, useCapture);
}
public static function dispatchEvent(event:Event):void {
	if (!_staticEventDispatcher) _staticEventDispatcher = new EventDispatcher();
	_staticEventDispatcher.dispatchEvent(event);
}
