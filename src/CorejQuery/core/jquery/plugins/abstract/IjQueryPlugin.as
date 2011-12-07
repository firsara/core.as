package core.jquery.plugins.abstract
{
	import core.jquery.jQuery;

	public interface IjQueryPlugin
	{
		function get self():jQuery;
		function set self(value:jQuery):void;
		
		function die():void;
	}
}