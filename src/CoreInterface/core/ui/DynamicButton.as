package core.ui
{
	import core.animation.Tween;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[ExcludeClass]
	public dynamic class DynamicButton extends Sprite
	{
		private var _default:DisplayObject;
		private var _hover  :DisplayObject;
		private var _down   :DisplayObject;
		private var _text   :String;
		private var _style  :String;
		private var _label  :Label;
		
		public function set defaultStyle(value:DisplayObject):void
		{
			_default = value;
			draw();
		}
		
		public function set hoverStyle(value:DisplayObject):void
		{
			_hover = value;
			draw();
		}
		
		public function set downStyle(value:DisplayObject):void
		{
			_down = value;
			draw();
		}
		
		public function set label(value:String):void
		{
			_text = value;
			draw();
		}
		
		public function set style(value:String):void
		{
			_style = value;
			draw();
		}
		
		
		private function draw():void
		{
			while (this.numChildren > 0) this.removeChildAt(0);
			
			_label = new Label(_text, _style);
			_label.x = (Math.max(_default.width, _hover.width, _down.width) - _label.width) * .5;
			_label.y = (Math.max(_default.height, _hover.height, _down.height) - _label.height) * .5;
			_label.mouseEnabled = false;
			
			this.addChild(_default);
			this.addChild(_hover);
			this.addChild(_down);
			this.addChild(_label);
			
			_hover.alpha = 0;
			_down.alpha = 0;
		}
		
		
		
		private function show(child:DisplayObject):void { if (child != null) Tween.start(child).fadeIn(Tween.NORMAL, Tween.EASE_IN_OUT); }
		private function hide(child:DisplayObject):void { if (child != null) Tween.start(child).fadeOut(Tween.NORMAL, Tween.EASE_IN_OUT); }
		
		
		private function mouseOver (e:MouseEvent):void { show(_hover); hide(_down); }
		private function mouseOut  (e:MouseEvent):void { hide(_hover); hide(_down); }
		private function mouseDown (e:MouseEvent):void { show(_down); }
		private function mouseUp   (e:MouseEvent):void { hide(_down); }
		
		
		
		public function DynamicButton()
		{
			super();
			this.buttonMode = true;
			_text = 'DynamicButton';
			_style = 'core.ui.DynamicButton';
			
			_default = new Sprite();
			_hover = new Sprite();
			_down = new Sprite();
			
			this.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}