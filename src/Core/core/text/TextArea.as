package core.text
{
	public class TextArea extends Text
	{
		public function TextArea(value:String = '', styleName:String = '', html:Boolean = true)
		{
			super(value, styleName, html);
			this.multiline = true;
			//this.wordWrap = true;
		}
		
	}
}
