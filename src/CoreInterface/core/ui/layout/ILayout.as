package core.ui.layout
{
	import flash.events.Event;

	public interface ILayout
	{
		function get padding():Number;
		function set padding(value:Number):void;
		
		function get horizontalSpreadType():String;
		function set horizontalSpreadType(value:String):void;
		
		function get verticalSpreadType():String;
		function set verticalSpreadType(value:String):void;
	}
}