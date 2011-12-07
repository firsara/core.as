package core.fonts
{
	import flash.text.Font;
	
	public class HelveticaNeueLight 
	{
		include '../_inc_/StaticRequire.as';
		public static const NAME:String = 'Helvetica Neue Light';
		
		public function HelveticaNeueLight():void
		{
			include '../_inc_/StaticRequireValidation.as';
			[Embed(source='data/HelveticaNeue/Helvetica Neue Light.ttf', fontName="Helvetica Neue Light", mimeType="application/x-font-truetype", embedAsCFF="false")]
			var HelveticaNeueLight:Class;
			
			Font.registerFont(HelveticaNeueLight);
		}
		
	}
}
