package core.text
{
	public class TextAlign
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		private var _type:String;
		
		public function get type():String { return _type; }
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function TextAlign(type:String = LEFT)
		{
			_type = type;
		}
		
	}
}
