package core.ui.controls.abstract
{
	public interface IAbstractControl
	{
		function get ready():Boolean
		
		function tint():void;
		
		function set width(value:Number):void;
		
		function construct():void;
		function dispose():void;
		function draw():void;
	}
}