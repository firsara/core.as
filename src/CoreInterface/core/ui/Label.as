package core.ui
{
	import core.text.Text;
	import core.text.TextStyles;
	import core.ui.assets.UIAssets;
	
	public class Label extends Text
	{
		public function Label(value:String = "", styleName:String = "", html:Boolean = true)
		{
      if (!UIAssets.ready) UIAssets.init();
			if (styleName == "") styleName = TextStyles.LABEL;
			
			super(value, styleName, html);
			this.selectable = false;
		}

	}
}
