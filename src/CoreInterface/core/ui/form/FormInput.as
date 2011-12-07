package core.ui.form
{
	import core.api.def.stage;
	import core.text.Text;
	import core.ui.events.FormEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	public class FormInput extends Sprite
	{
		private var _label:Text;
		private var _input:Text;
		private var _defaultValue:String;
		
		
		public function get value():String { return _input.text; }
		
		public function get label():String { return _label.text; }
		public function set label(value:String):void
		{
			_label.text = value;
			_input.x = _label.width + 10;
		}
		
		public function get inputDefaultValue():String { return _defaultValue; }
		public function set inputDefaultValue(value:String):void
		{
			_input.text = value;
		}
		
		public function FormInput(label:String = '', inputDefaultValue:String = '')
		{
			_label = new Text(label, 'Label', true);
			_input = new Text(inputDefaultValue, 'Input', true);
			_input.selectable = true;
			_input.type = TextFieldType.INPUT;
			
			_defaultValue = inputDefaultValue;
			
			_input.x = _label.width + 10;
			
			this.addChild(_label);
			this.addChild(_input);
			
			_input.addEventListener(MouseEvent.CLICK, clearDefaultValue);
			core.api.def.stage.addEventListener(MouseEvent.CLICK, resetDefaultValue);
			core.api.def.stage.addEventListener(KeyboardEvent.KEY_UP, fetchKeyValue);
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		private function clearDefaultValue(e:MouseEvent):void
		{
			_input.text = '';
		}
		
		private function resetDefaultValue(e:MouseEvent):void
		{
			if (e.target != _input && _input.text == '') _input.text = _defaultValue;
		}
		
		private function fetchKeyValue(e:KeyboardEvent):void
		{
			if (e.keyCode == 13)
			{
				this.dispatchEvent(new FormEvent(FormEvent.SUBMIT));
			}
		}
		
		
		private function dispose(e:Event):void
		{
			_input.removeEventListener(MouseEvent.CLICK, clearDefaultValue);
			core.api.def.stage.removeEventListener(MouseEvent.CLICK, resetDefaultValue);
			core.api.def.stage.removeEventListener(KeyboardEvent.KEY_UP, fetchKeyValue);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
	}
}