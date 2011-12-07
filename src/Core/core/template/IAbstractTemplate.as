package core.template
{
	import flash.display.Sprite;

	public interface IAbstractTemplate
	{
		function get holder():Sprite;
		function set holder(value:Sprite):void;
		
		function get parameters():Object;
		function set parameters(value:Object):void;
		
		function get width  ()    :Number;
		function set width  (value:Number):void;
		function get height ()    :Number;
		function set height (value:Number):void;
		
		function render():void;
		function die():void;
	}
}