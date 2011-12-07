package core.fonts
{
	import flash.text.Font;
	
	public class HelveticaNeueUltraLight 
	{
		include '../_inc_/StaticRequire.as';
		public static const NAME:String = 'Helvetica Neue UltraLight';
		
		public function HelveticaNeueUltraLight():void
		{
			include '../_inc_/StaticRequireValidation.as';
			
			[Embed(source='data/HelveticaNeue/Helvetica Neue UltraLight.ttf', fontName="Helvetica Neue UltraLight", mimeType="application/x-font-truetype", embedAsCFF="false")]
			var HelveticaNeueUltraLight:Class;
			
			Font.registerFont(HelveticaNeueUltraLight);
		}
		
	}
}
