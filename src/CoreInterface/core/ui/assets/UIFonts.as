package core.ui.assets
{
	import core.text.Style;
	
	import flash.text.Font;
	import flash.utils.ByteArray;
	
  [ExcludeClass] public class UIFonts 
	{
		[Embed(source='Helvetica Neue.ttf', 
					 fontName="UIFont",
					 mimeType="application/x-font-truetype",
					 embedAsCFF="false")] static private const UIFont:Class;
		
		[Embed(source='Helvetica Neue Bold.ttf',
					 fontName="UIFont",
					 fontWeight="bold",
					 mimeType="application/x-font-truetype",
					 embedAsCFF="false")] static private const UIFontBold:Class;
		
		[Embed(source='styles.xml',
					 mimeType="application/octet-stream")] static private const StyleXML:Class;
		
    private static var _ready:Boolean;
    
		public static function init():void
		{
      if (_ready) return;
      _ready = true;
      
			Font.registerFont(UIFontBold);
			Font.registerFont(UIFont);
			
			var file:ByteArray = new StyleXML();
			var xmlData:String = file.readUTFBytes(file.length);
			Style.extend(new XML(xmlData));
		}
		
	}
}
