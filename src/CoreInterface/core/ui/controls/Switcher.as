package core.ui.controls
{
  import core.actions.tint;
  import core.api.Lib;
  import core.api.def.stage;
  import core.display.MoveClip;
  import core.ui.UI;
  import core.ui.controls.abstract.AbstractControl;
  
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  
  public class Switcher extends AbstractControl
  {
    private var _on:DisplayObject;
    private var _off:DisplayObject;
		private var _handle:DisplayObject;
    private var _mover:MoveClip;
    private var _mask:DisplayObject;
    private var _active:Boolean;
    
    override public function tint():void
    {
			if (this.ready) core.actions.tint(_on, UI.color);
    }
		
		override public function get width():Number
		{
			return _on.width;
		}
    
    public function get active():Boolean { return _active; }
    
    [Inspectable]
    public function set active(value:Boolean):void
    {
      _active = value;
      if (ready) _mover.moveTo((value ? _mover.borders.x[1] : 0));
			else _mover.x = (value ? _mover.borders.x[1] : 0);
    }
		
    
    
		override public function draw():void
		{
      _mover = new MoveClip();
			_mover.buttonMode = true;
      
			_handle = Lib.get('ui/switcher/switcher.handle');
      _off = Lib.get('ui/switcher/switcher.off');
      _on = Lib.get('ui/switcher/switcher.on');
			
			_on.x = 0 - _on.width;
			_off.x = _handle.width;
			
			_on.x = 0 - _on.width + _handle.width;
			_off.x = 0;
			
			_mover.addChild(_off);
			_mover.addChild(_on);
			_mover.addChild(_handle);
      
			_mask = Lib.get('ui/switcher/switcher.on');
			_mask.width = _mask.width - 2; _mask.x = 1;
			
			_mover.cacheAsBitmap = true;
			_mask.cacheAsBitmap = true;
			
			this.addChild(Lib.get('ui/switcher/switcher.off'));
			this.addChild(_mover);
      this.addChild(_mask);
      
			_mover.mask = _mask;
      
      _mover.borders.x = [0, _on.width - _handle.width];
      _mover.borders.y = [0, 0];
      _mover.snap = _on.width - _mover.width;
      _mover.friction.release = 0.3;
			
			this.active = this.active;
		}
		
		
		override public function construct():void
		{
			this.addEventListener(MouseEvent.CLICK, setActive);
      core.api.def.stage.addEventListener(MouseEvent.MOUSE_UP, fetchValue);
    }
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK, setActive);
			core.api.def.stage.removeEventListener(MouseEvent.MOUSE_UP, fetchValue);
		}
		
    
    
    private function setActive(event:MouseEvent):void
    {
      if (this.mouseX > _on.width / 2)
			     active = true;
      else active = false;
    }
    
    
    
    private function fetchValue(event:MouseEvent):void
    {
      if (_mover.x > _on.width / 2)
           _active = true;
      else _active = false;
    }
    
    
  }
}
