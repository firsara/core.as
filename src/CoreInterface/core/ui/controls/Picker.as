package core.ui.controls
{
  import core.api.Lib;
  import core.api.def.stage;
  import core.events.MoveEvent;
  import core.ui.controls.abstract.AbstractControl;
  import core.ui.controls.base.Roller;
  
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  public class Picker extends AbstractControl
  {
		private var _background:DisplayObject;
    private var _left:DisplayObject;
		private var _right:Sprite;
		private var _content:DisplayObject;
		private var _shadow:Sprite;
		private var _bar:Sprite;
		private var _separator:DisplayObject;
		private var _contentHolder:Sprite;
		
		
		// CONTENT
		private var _roller:Roller;
    
		private var _size:Number = 320;
		private var _pickerSize:Number = 240;
    
		
		override public function tint():void
		{
		}
		
		override public function get height():Number
		{
			return _background.height;
		}
    
		override public function draw():void
		{
			var temp:DisplayObject;
			
			_background = Lib.get('ui/picker/picker.background');
			_left = Lib.get('ui/picker/picker.left');
			_content = Lib.get('ui/picker/picker.content');
			_right = new Sprite();
			_shadow = new Sprite(); _shadow.addChild( Lib.get('ui/picker/picker.shadow') );
			_bar = new Sprite(); _bar.addChild( Lib.get('ui/picker/picker.bar') );
			
			
			temp = Lib.get('ui/picker/picker.left');
			temp.x = temp.width;
			temp.scaleX = -1;
			_right.addChild(temp);
			
			_shadow.mouseEnabled = _shadow.mouseChildren = false;
			_bar.mouseEnabled = _bar.mouseChildren = false;
			
			
			_roller = new Roller();
			_roller.list = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
			
			_contentHolder = new Sprite();
			_contentHolder.addChild(_left);
			_contentHolder.addChild(_right);
			_contentHolder.addChild(_content);
			_contentHolder.addChild(_roller);
			_contentHolder.addChild(_shadow);
			_contentHolder.addChild(_bar);
			
			this.addChild(_background);
      this.addChild(_contentHolder);
      
			rearrange();
		}
		
		
		override public function construct():void
		{
			_roller.construct();
      //_handle.addEventListener(MoveEvent.POSITION_UPDATE, keepMask);
      core.api.def.stage.addEventListener(MouseEvent.MOUSE_UP, fetchValue);
    }
		
		override public function dispose():void
		{
			_roller.dispose();
			core.api.def.stage.removeEventListener(MouseEvent.MOUSE_UP, fetchValue);
			//_handle.removeEventListener(MoveEvent.POSITION_UPDATE, keepMask);
		}
		
		
		
		
    private function rearrange():void
		{
			_background.width = _size;
			_content.width = _pickerSize;
			
			_content.x = _left.width;
			_right.x = _content.x + _content.width;
			_bar.x = _content.x - 12;
			_bar.y = (_content.height - _bar.height) *.5;
			
			_shadow.x = _content.x;
			_shadow.width = _content.width;
			
			_contentHolder.x = (_background.width - _content.width) *.5;
			_contentHolder.y = (_background.height - _content.height) *.5 + 3;
			
			_roller.setBounds(100, 195);
			_roller.x = 30;
			_roller.y = 3;
		}
    
    
    
    private function keepMask(event:MoveEvent = null):void
    {
      //_mask.width = _handle.x + 4;
			//_on.x = _handle.x - _on.width + _handle.width;
    }
    
    private function fetchValue(event:MouseEvent):void
    {
      //if (_handle.x > this.width / 2)
        //_active = true;
      //else _active = false;
    }
    
    
  }
}
