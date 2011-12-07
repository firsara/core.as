package core.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class DynamicText extends Text
	{
		public function DynamicText(value:String = '', textFormatParameters:Object = null, textFieldParameters:Object = null, html:Boolean = true)
		{
			super(value, '', true);
			format(this, textFormatParameters, textFieldParameters);
		}
		
		public static function format(target:TextField, textFormatParameters:Object = null, textFieldParameters:Object = null):void
		{
			var format:TextFormat = target.getTextFormat();
			var key:String;
			
			// TEXT FORMAT
			if (textFormatParameters)
			{
				for (key in textFormatParameters)
				{
					try
					{
						format[key] = textFormatParameters[key];
					}
					catch(e:Error)
					{
						trace('cannot create property ' + key + ' in TextFormat');
					}
				}
			}
			
			// TEXT FIELD
			if (textFieldParameters)
			{
				for (key in textFieldParameters)
				{
					try
					{
						target[key] = textFieldParameters[key];
					}
					catch(e:Error)
					{
						trace('cannot create property ' + key + ' in Dynamic Text');
					}
				}
			}
			
			target.embedFonts = Text.fontRegistered(format.font);
			target.setTextFormat(format);
			target.defaultTextFormat = format;
		}
	}
}