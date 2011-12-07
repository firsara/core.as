package core.settings
{
	import flash.ui.MultitouchInputMode;
	
	[ExcludeClass]
	public final class InputSetup
	{
		// core.api.app.helper.InputHandler
		//static public const inputMode              :String  = MultitouchInputMode.NONE;
		static public const inputMode              :String  = 'mouse';
		static public const clickMaxMove           :Number = 10;
		static public const clickMaxTime           :Number = 200;
	}
}