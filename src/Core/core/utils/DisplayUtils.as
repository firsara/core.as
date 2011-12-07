package core.utils {
	
	import core.api.def.stage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public final class DisplayUtils
  {
    public static function realWidth(displayObject:*):Number
    {
      return (displayObject is Stage ? displayObject.stageWidth : displayObject.width);
    }
    
    public static function realHeight(displayObject:*):Number
    {
			return (displayObject is Stage ? displayObject.stageHeight : displayObject.height);
    }
		
		
		
		public static function replaceChildren(child1:DisplayObjectContainer, child2:DisplayObjectContainer):Boolean
		{
			if (child1.parent != null)
			{
				child2.x = child1.x
				child2.y = child1.y;
				child1.parent.addChild(child2);
				child1.parent.removeChild(child1);
				
				return true;
			}
			else if (child2.parent != null)
			{
				child1.x = child2.x
				child1.y = child2.y;
				child2.parent.addChild(child1);
				child2.parent.removeChild(child2);
				
				return true;
			}
			
			return false;
		}
		
    
    
    // DISPLAY MANIPULATION
		public static function overlay(source:Sprite):void
    {
			var temp:MovieClip = new MovieClip();
			temp.graphics.beginFill(0xFF0000, 0);
			temp.graphics.drawRect(0, 0, source.width, source.height);
			temp.graphics.endFill();
			temp.name = "overlay";
			
			source.addChild(temp);
		}
		
		public static function underlay(source:Sprite):void
    {
			var temp:MovieClip = new MovieClip();
			temp.graphics.beginFill(0xFF0000, 0);
			temp.graphics.drawRect(0, 0, source.width, source.height);
			temp.graphics.endFill();
			temp.name = "underlay";
			
			source.addChild(temp);
			source.setChildIndex(temp, 0);
		}
		
		public static function get screenshot():Bitmap
		{
			return getSegment(0, 0, core.api.def.stage.stageWidth, core.api.def.stage.stageHeight, core.api.def.stage);
		}
		
		public static function getSegment(x      :Number,
																			y      :Number,
																			width  :Number,
																			height :Number,
																			source :DisplayObject):Bitmap
		{
			var area:Rectangle = new Rectangle(0, 0, width, height);
			var img:Bitmap = new Bitmap(new BitmapData(width, height), PixelSnapping.ALWAYS, true);
			img.bitmapData.draw(source, new Matrix(1, 0, 0, 1, - x, - y) , null, null, area, true);
			
			return img;
		}
		
		
		public static function resizeWidth(obj:DisplayObject, thumbWidth:Number = -1, drawCentered:Boolean = true):Bitmap
		{
			return resize(obj, thumbWidth, -1, drawCentered);
		}
		
		public static function resizeHeight(obj:DisplayObject, thumbHeight:Number = -1, drawCentered:Boolean = true):Bitmap
		{
			return resize(obj, -1, thumbHeight, drawCentered);
		}
		
		public static function resize(obj:DisplayObject, thumbWidth:Number = -1, thumbHeight:Number = -1, drawCentered:Boolean = true):Bitmap
		{
			var scale:Number;
			var matrix:Matrix;
			var bitmapData:BitmapData;
			
			scale = (obj.scaleX + obj.scaleY) / 2;
			
			if (thumbWidth == -1 && thumbHeight == -1)
			{
				thumbWidth = obj.width;
				thumbHeight = obj.height;
			}
			else if (thumbHeight == -1)
			{
				obj.width = thumbWidth;
				obj.scaleY = obj.scaleX;
				thumbHeight = obj.height;
			}
			else if (thumbWidth == -1)
			{
				obj.height = thumbHeight;
				obj.scaleX = obj.scaleY;
				thumbWidth = obj.width;
			}
			
			obj.scaleX = obj.scaleY = scale;
			
			matrix = new Matrix();
			bitmapData = new BitmapData(thumbWidth, thumbHeight, true);
			scale = Math.max(thumbWidth / obj.width, thumbHeight / obj.height);
			if (drawCentered) matrix.translate((obj.width * scale - thumbWidth) * -.5,(obj.height * scale - thumbHeight) * -.5);
			matrix.scale(scale, scale);
			
			bitmapData.draw(obj, matrix, null, null, null, true);
			
			return new Bitmap(bitmapData);
		}


	}
}
