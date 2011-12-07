package core.text
{
	import core.api.Config;
	import core.actions.log;
	
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Text extends TextField
  {
		static public var defaultTextFormat:TextFormat = new TextFormat("Helvetica", 14, 0x000000);
		
		private var _fontBold:String;
		private var _formatStyle:Style;
		private var _html:Boolean;
		private var _valKey:String;
		
		
		public function get fontBold():String           { return _fontBold; }
		public function get formatStyle():Style         { return _formatStyle; }
		public function get value():String              { return this[_valKey]; }
		public function get html():Boolean              { return _html; }
		
		public function set value(val:String):void      { this[_valKey] = String(val); }
		public function set fontBold(val:String):void   { _fontBold = val; }
		public function set formatStyle(val:Style):void { _formatStyle = val; }
		
		public function set html(htmlEnabled:Boolean):void {
			_html = htmlEnabled;
			_valKey = (_html ? 'htmlText' : 'text');
			
			if(htmlEnabled) this.htmlText = this.text;
			else            this.text = this.htmlText;
		}
		
		public function set htmlValue(val:String):void {
			if(_fontBold) {
				this[_valKey] = secureValue(val, _fontBold);
			}
		}
		
		
		
		// CONSTRUCTION
		
		public function Text(value:String = "", styleName:String = "", html:Boolean = true) {
			super();
			if (value == null) value = '';
			value = String(value);
			
			_html = html;
			_valKey = (_html ? 'htmlText' : 'text');
			
			format(this, styleName);
			
			this[_valKey] = value;
		}
		
		
		
		public static function format(target:TextField, styleName:String = ""):void
    {
			
			function setProperties(propertiesNode:XML):void
			{
				for each (var prop:XML in propertiesNode.children()) {
					target[String(prop.name())] = prop;
				}
			}
		
			
			var formatStyle:TextFormat;
			
			if (Style.ready) formatStyle = new Style(styleName);
			else             formatStyle = defaultTextFormat;
			
			target.defaultTextFormat = formatStyle;
			
			target.selectable = false;
			target.multiline = false;
			target.wordWrap = false;
			target.mouseWheelEnabled = false;
			target.autoSize = TextFieldAutoSize.LEFT;
			target.gridFitType = GridFitType.PIXEL;
			//target.antiAliasType = AntiAliasType.ADVANCED;
			
			target.embedFonts = fontRegistered(formatStyle.font);
			
			if (Style.ready)
			{
				if (target is Text)
				{
					Text(target).fontBold = Style(formatStyle).fontBold;
					Text(target).formatStyle = Style(formatStyle);
				}
				
				if (Style.data.Default.TextField.length() == 1)      setProperties(new XML(Style.data.Default.TextField));
				if (Style(formatStyle).node.TextField.length() == 1) setProperties(new XML(Style(formatStyle).node.TextField));
			}
			
			target.setTextFormat(formatStyle);
			
			if (Config.instance.debug)
			{
				if(fontRegistered(formatStyle.font))
				     core.actions.log("core.text.Text -> " + formatStyle.font + " is Registered");
				else core.actions.log("core.text.Text -> " + formatStyle.font + " is NOT Registered");
			}
		}
		
		
		
		
		
		public static function fontRegistered(font:String):Boolean
		{
			var registeredFonts:Array = Font.enumerateFonts();
			
			for (var i:int = 0; i < registeredFonts.length; i++) {
				if (registeredFonts[i].fontName == font)
				{
					if (Config.instance.debug) trace('font ' + font + ' is registered');
					return true;
				}
			}
			
			if (Config.instance.debug) trace('font ' + font + ' NOT registered');
			
			return false;
		}
		
		
		
		private static function secureValue(val:String, _fontBold:String):String
		{
			var tempValue:String = val;
			tempValue = tempValue.replace(/<strong>/gi, "<b>");
			tempValue = tempValue.replace(/<\/strong>/gi, "</b>");
			//TempValue = TempValue.replace(/<b>/gi, '<font face="' + _fontBold + '"><b>');
			//TempValue = TempValue.replace(/<\/b>/gi, "<b></font>");
			
			return tempValue;
		}
		
	}
	
}
