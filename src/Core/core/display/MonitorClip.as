package core.display
{
  import core.actions.dynamicFunctionCall;
  import core.events.MonitorEvent;
  import core.utils.DisplayUtils;
  
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;

  public class MonitorClip extends Sprite
  { 
    private static var _objects:Array;
    private static var _counter:int;
    private static var _object:MonitorObject;
    private static var _objectCount:int;
    
    private static var _vars:Object;
    
    {
      _objects = new Array();
      _vars = {};
    }
    
    public static function monitor(target:DisplayObject,
																	 moveCallback:Function = null,
																	 resizeCallback:Function = null,
																	 displayListChangeCallback:Function = null):void
    {
      _object = new MonitorObject();
      _object.target = target;
      _object.moved = moveCallback;
      _object.resized = resizeCallback;
			_object.displayListChanged = displayListChangeCallback;
      
      _objects.push(_object);
      _objectCount = _objects.length;
      
      target.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
      target.addEventListener(Event.ENTER_FRAME, checkClip);
    }
    
    public static function unmonitor(target:DisplayObject):void
    {
			var id:int = getID(target);
			if (id != -1) _objects.splice(id, 1);
      _objectCount = _objects.length;
      
      target.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
      target.removeEventListener(Event.ENTER_FRAME, checkClip);
    }
    
    public function MonitorClip()
    {
      monitor(this);
    }
    
    private static function checkClip(e:Event):void
    {
      _object = MonitorObject(_objects[getID(DisplayObject(e.currentTarget))]);
      _vars.x = e.currentTarget.x;
      _vars.y = e.currentTarget.y;
      _vars.width = DisplayUtils.realWidth(e.currentTarget);
      _vars.height = DisplayUtils.realHeight(e.currentTarget);
			_vars.numChildren = e.currentTarget.numChildren;
      
			// POSITION
      if (_vars.x != _object.x || _vars.y != _object.y)
			{
        _object.x = _vars.x;
        _object.y = _vars.y;
        _vars.event = new MonitorEvent(MonitorEvent.MOVE, _vars.x, _vars.y, _vars.width, _vars.height);
        e.currentTarget.dispatchEvent(_vars.event);
				if (_object.moved != null) core.actions.dynamicFunctionCall(_object.moved, _vars.event);
      }
			
			// SIZE
      if (_vars.width != _object.width || _vars.height != _object.height)
			{
        _object.width = _vars.width;
        _object.height = _vars.height;
        _vars.event = new MonitorEvent(MonitorEvent.RESIZE, _vars.x, _vars.y, _vars.width, _vars.height);
        e.currentTarget.dispatchEvent(_vars.event);
				if (_object.resized != null) core.actions.dynamicFunctionCall(_object.resized, _vars.event);
      }
			
			// DISPLAY LIST
			if (_vars.numChildren != _object.numChildren)
			{
				_object.numChildren = _vars.numChildren;
				_vars.event = new MonitorEvent(MonitorEvent.CHANGE_DISPLAY_LIST, _vars.x, _vars.y, _vars.width, _vars.height);
				e.currentTarget.dispatchEvent(_vars.event);
				if (_object.displayListChanged != null) core.actions.dynamicFunctionCall(_object.displayListChanged, _vars.event);
			}
    }
    
    private static function dispose(e:Event):void
    {
      e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
      e.currentTarget.removeEventListener(Event.ENTER_FRAME, checkClip);
    }
    
    
    
    // HELPER FUNCTIONS
    private static function getID(target:DisplayObject):int
    {
      _counter = 0;
      
      for each (_object in _objects)
      {
        if (_object.target == target) return _counter;
        
        _counter++;
      }
      
      return -1;
    }
    
  }
}

import flash.display.DisplayObject;

internal dynamic class MonitorObject
{
  public var x:Number;
  public var y:Number;
  public var width:Number;
	public var height:Number;
	public var numChildren:int;
  public var target:DisplayObject;
  public var moved:Function;
	public var resized:Function;
	public var displayListChanged:Function;
}