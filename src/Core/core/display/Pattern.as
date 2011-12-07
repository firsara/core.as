package core.display
{
	import core.utils.DisplayUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Pattern extends Sprite
	{
		private var _bitmapReference:BitmapData;
		
		public function Pattern(source:* = null)
		{
			super();
			if (source != null) this.source = source;
		}
		
		public function set source(data:*):void
		{
			if (data is Class)
			{
				// EMBEDDED OR LIBRARY BITMAP
				var temp:* = new (data as Class)();
				this.source = temp;
			}
			else if (data is BitmapData) _bitmapReference = (data as BitmapData);
			else if (data is Bitmap)     _bitmapReference = (data as Bitmap).bitmapData;
			else if (data is DisplayObject)
			{
				var bmp:Bitmap = DisplayUtils.getSegment(0, 0, data.width, data.height, data);
				_bitmapReference = bmp.bitmapData;
			}
			else
			{
				throw new Error('cannot use ' + data + ' as source for Pattern');
			}
		}
		
		public function draw(width:Number, height:Number):void
		{
			this.graphics.clear();
			this.graphics.beginBitmapFill(_bitmapReference);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
	}
}
