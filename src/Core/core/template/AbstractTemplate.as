package core.template
{
	import flash.display.Sprite;

	public class AbstractTemplate implements IAbstractTemplate
	{
		private var _parameters : Object;
		private var _holder     : Sprite;
		private var _width      : Number;
		private var _height     : Number;
		private var _template   : TemplateEngine;
		
		public final function get holder():Sprite
		{
			if (_holder == null) _holder = new Sprite();
			return _holder;
		}
		
		public final function set holder(value:Sprite):void
		{
			_holder = value;
		}
		
		
		public final function get parameters():Object { return _parameters; }
		public final function set parameters(value:Object):void
		{
			if (value == null) value = new Object();
			_parameters = value;
			
			this.width = Number(value.width);
			this.height = Number(value.height);
		}
		
		
		public final function get template()    :TemplateEngine       { return _template; }
		public final function set template(value:TemplateEngine):void { _template = value; }
		
		public final function get width  ():Number           { return _width | 0; }
		public final function set width  (value:Number):void { _width = value; resize(); }
		public final function get height ():Number           { return _height | 0; }
		public final function set height (value:Number):void { _height = value; resize() }
		
		
		
		
		public function render():void
		{
		}
		
		
		protected function resize():void
		{
		}
		
		public function die():void
		{
			_holder = null;
			_parameters = null;
		}
		
		
		public function AbstractTemplate()
		{
		}
	}
}