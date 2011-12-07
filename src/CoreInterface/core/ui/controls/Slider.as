package core.ui.controls
{
  import core.actions.tint;
  import core.api.Lib;
  import core.display.MoveClip;
  import core.events.MoveEvent;
  import core.ui.UI;
  import core.ui.controls.abstract.AbstractControl;
  
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  
  public class Slider extends AbstractControl
  {
    private var _left:DisplayObject;
    private var _right:DisplayObject;
    private var _empty:DisplayObject;
    private var _fill:DisplayObject;
		private var _bar:Sprite;
    private var _handle:MoveClip;
    
    private var _size:Number;
		private var _min:Number;
		private var _max:Number;
		private var _value:Number;
    
		public function get percentage():Number { return (_handle.x / _size); }
		public function get max():Number        { return (_max || 100); }
		public function get min():Number        { return (_min || 0); }
		public function get value():Number      { return (this.percentage * _max + _min); }
    public function get size():Number       { return _size; }
		
		
		override public function tint():void
		{
			if (this.ready) core.actions.tint(_fill, UI.color);
		}
		
		
		public function set percentage(value:Number):void
		{
			_handle.x = value * size;
			rearrange();
			keepBounds();
		}
		
		[Inspectable(name="Minimum Value", type=Number, defaultValue=0)]
		public function set min(value:Number):void
		{
			_min = value;
			this.value = Math.max(_min, this.value);
		}
		
		[Inspectable(name="Maximum Value", type=Number, defaultValue=100)]
		public function set max(value:Number):void
		{
			_max = value;
			this.value = Math.min(_max, this.value);
		}
		
		[Inspectable(name="Value", type=Number, defaultValue=0)]
		public function set value(value:Number):void
		{
			_value = value;
			this.percentage = (value - _min) / (_max - _min);
		}
		
    [Inspectable(name="Size", type=int, format="Length", defaultValue=100)]
    public function set size(value:Number):void
    {
			if (isNaN(value)) value = 100;
			
      _size = Math.max(50, value);
			this.percentage = this.percentage;
    }
    
    
    
    
    override public function draw():void
    {
      var temp:DisplayObject = Lib.get('ui/slider/slider.handle');
      temp.x = temp.width*-.5;
      //temp.y = temp.height*-.5;
      
      _handle = new MoveClip();
      _handle.buttonMode = true;
      _handle.addChild(temp);
			
			_bar = new Sprite();
      
      _left = Lib.get('ui/slider/slider.background.left');
      _right = Lib.get('ui/slider/slider.background.right');
      _empty = Lib.get('ui/slider/slider.background.empty');
      _fill = Lib.get('ui/slider/slider.background.fill');
			
			_bar.addChild(_left);
			_bar.addChild(_right);
			_bar.addChild(_empty);
			_bar.addChild(_fill);
			
      
      addChild(_bar);
      addChild(_handle);
      
      _handle.snap = 1;
      _handle.friction.release = 0;
			
			
			this.value = _value;
			this.size = this.size;
			this.min = this.min;
			this.max = this.max;
		}
    
		
		override public function construct():void
		{
      _handle.addEventListener(MoveEvent.POSITION_UPDATE, keepBounds);
			//_bar.addEventListener(InputEvent.INPUT_DOWN, barDown);
    }
		
		override public function dispose():void
		{
			_handle.removeEventListener(MoveEvent.POSITION_UPDATE, keepBounds);
			//_bar.removeEventListener(InputEvent.INPUT_DOWN, barDown);
		}
    
    
    
    
    private function rearrange():void
    {
      _right.x = _size - _right.width;
      _empty.x = _left.width;
      _empty.width = _right.x - _empty.x;
      _fill.x = _empty.x;
      _left.y = _empty.y = _fill.y = _right.y = Math.round((_handle.height - _left.height) / 2);
      
      _handle.borders.x = [0, this.width - _handle.width / 2];
      _handle.borders.y = [0, 0];
    }
    
    private function keepBounds(event:MoveEvent = null):void
    {
      _fill.width = _handle.x;
    }
		
		
		//private function barDown(event:*):void
		//{
			//_handle.x = event.localX;
			//_handle.startClipDrag(event);
		//}
    
    
  }
}
