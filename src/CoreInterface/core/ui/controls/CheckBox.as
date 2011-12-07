package core.ui.controls
{
	import core.Core;
	import core.settings.TweenSetup;
	import core.animation.Tween;
	import core.api.Lib;
	import core.text.Text;
	import core.text.TextAlign;
	import core.ui.Label;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import core.ui.controls.abstract.AbstractControl;
	
	public class CheckBox extends AbstractControl
	{
		private const STYLES:Array = ["CheckBox", "CheckBox.off"];
		
		private var _trigger:Sprite;
		private var _on:DisplayObject;
		private var _off:DisplayObject;
		private var _label:Label;
		private var _active:Boolean;
    private var _value:String;
		private var _align:String;
		
    public function get align():String { return _align; }
    public function get value():String { return _value; }
    public function get active():Boolean { return _active; }
    
		
		override public function tint():void
		{
		}
		
    [Inspectable(name="Label align", enumeration="left, right", type=String, defaultValue="left")]
		public function set align(value:String):void
		{
			_align = value;
			rearrange();
		}
    
		[Inspectable(name="Label", type=String, defaultValue='Checkbox')]
		public function set value(value:String):void
		{
      _value = String(value);
			if (_value == 'null') _value = 'Checkbox';
      _label.value = _value;
			rearrange();
		}
		
    [Inspectable(name="Active", type=Boolean, defaultValue=false)]
		public function set active(value:Boolean):void
		{
			_active = value;
      if (ready) fade(value, TweenSetup.tweenSpeedNormal);
			else _on.alpha = (_active ? 1 : 0);
			
			Text.format(_label, String(STYLES[value ? 0 : 1]));
			rearrange();
		}
		
		
		
    
    override public function draw():void
    {
			_trigger = new Sprite();
			_trigger.graphics.beginFill(0xFF0000, 0);
			_trigger.graphics.drawRect(0, 0, 100, 100);
			_trigger.graphics.endFill();
			
			_off = Lib.get('ui/checkbox/checkbox.off');
			_on = Lib.get('ui/checkbox/checkbox.on');
			_label = new Label(value, STYLES[0]);
			
			addChild(_off);
			addChild(_on);
			addChild(_label);
			addChild(_trigger);
			
			this.buttonMode = true;
			this.value = this.value;
			this.align = this.align;
			this.active = this.active;
			
			//fade(active, 0);
			//rearrange();
		}
		
		override public function construct():void
		{
			this.addEventListener(MouseEvent.CLICK, setActive);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK, setActive);
		}
		
		
		
		private function fade(value:Boolean, speed:Number):void
		{
			Tween.stop(_on);
			Tween.to(_on, speed, {alpha: value ? 1 : 0});
		}
		
		private function rearrange():void
		{
			if (_label.height > _on.height)
			{
				_label.y = 0;
				_on.y = _off.y = (_label.height - _on.height) / 2;
			}
			else
			{
				_on.y = _off.y = 0;
				_label.y = (_on.height - _label.height) / 2;
			}
			
			if (String(_align).toLowerCase() == TextAlign.RIGHT.toLowerCase())
			{
				_on.x = _off.x = 0;
				_label.x = _on.width * 1.2;
        _trigger.x = _on.x;
			}
			else
			{
        _on.x = _off.x = 0;
        _label.x = 0 - _label.width - _on.width * 0.2;
        _trigger.x = _label.x;
				//_label.x = 0;
				//_on.x = _off.x = _label.width + _on.width * 0.2;
			}
			
			_trigger.width = 0;
			_trigger.height = 0;
			_trigger.width = _label.width + _on.width * 0.2;
			_trigger.height = this.height;
		}
		
		private function setActive(event:MouseEvent):void
		{
			active = !active;
		}
		
		
	}
}
