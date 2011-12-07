package core.events
{
  import flash.events.Event;

  public class MonitorEvent extends Event
  {
    public static const MOVE:String = 'move';
    public static const RESIZE:String = 'resize';
		public static const CHANGE_DISPLAY_LIST:String = 'changeDisplayList';
    
    
    private var _x:Number;
    private var _y:Number;
    private var _width:Number;
		private var _height:Number;
    
    public function get x():Number { return _x; }
    public function get y():Number { return _x; }
    public function get width():Number { return _width; }
		public function get height():Number { return _height; }
    
    public function MonitorEvent(type:String, x:Number, y:Number, width:Number, height:Number, bubbles:Boolean = false, cancelable:Boolean = false)
    {
      super(type, bubbles, cancelable);
      _x = x;
      _y = y;
      _width = width;
      _height = height;
    }
  }
}