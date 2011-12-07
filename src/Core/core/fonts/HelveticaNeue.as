package core.fonts
{
	import flash.text.Font;
	
	public class HelveticaNeue 
	{
		include '../_inc_/StaticRequire.as';
		public static const NAME:String = 'Helvetica Neue';
		
		public function HelveticaNeue():void
		{
			include '../_inc_/StaticRequireValidation.as';
			
			[Embed(source='data/HelveticaNeue/Helvetica Neue.ttf', fontName="Helvetica Neue", mimeType="application/x-font-truetype", embedAsCFF="false")]
			var HelveticaNeue:Class;
			
			[Embed(source='data/HelveticaNeue/Helvetica Neue Bold Italic.ttf', fontName="Helvetica Neue", fontWeight="bold", fontStyle="italic", mimeType="application/x-font-truetype", embedAsCFF="false")]
			var HelveticaNeueItalic:Class;
			
			[Embed(source='data/HelveticaNeue/Helvetica Neue Bold.ttf', fontName="Helvetica Neue", fontWeight="bold", mimeType="application/x-font-truetype", embedAsCFF="false")]
			var HelveticaNeueBold:Class;
			
			[Embed(source='data/HelveticaNeue/Helvetica Neue Italic.ttf', fontName="Helvetica Neue", fontStyle="italic", mimeType="application/x-font-truetype", embedAsCFF="false")]
			var HelveticaNeueBoldItalic:Class;
			
			Font.registerFont(HelveticaNeue);
			Font.registerFont(HelveticaNeueItalic);
			Font.registerFont(HelveticaNeueBold);
			Font.registerFont(HelveticaNeueBoldItalic);
		}
		
	}
}
