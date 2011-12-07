package core.jquery.plugins.abstract
{
	import core.jquery.jQuery;
	
	public class jQueryPlugin implements IjQueryPlugin
	{
		private var _self:jQuery;
		public function get self():jQuery           { return _self; }
		public function set self(value:jQuery):void { _self = value; }
		
		public function die():void
		{
		}
		
		public function jQueryPlugin()
		{
		}
	}
}