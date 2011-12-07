package core.display
{
	import core.animation.Tween;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	public dynamic class Flipable extends Sprite
	{
		private var _front:DisplayObject;
		private var _back:DisplayObject;
    private var _flipped:Boolean;
		
		public function get front():DisplayObject { return _front; }
		public function set front(child:DisplayObject):void
		{
			remove(_front);
			_front = child;
      _front.x = _front.width*-.5;
      _front.y = _front.height*-.5;
			this.addChild(_front);
		}
		
		public function get back():DisplayObject { return _back; }
		public function set back(child:DisplayObject):void
		{
			remove(_back);
			_back = child;
      _back.x = _back.width*-.5;
      _back.y = _back.height*-.5;
			this.addChild(_back);
		}
		
		
		public function Flipable(front:DisplayObject = null, back:DisplayObject = null)
		{
			super();
      
      if (front == null) front = new Sprite();
      if (back == null)  back = new Sprite();    
      
			this.front = front;
			this.back = back;
      
      _back.visible = false;
      _flipped = false;
			
			this.cacheAsBitmap = true;
			this.cacheAsBitmapMatrix = new Matrix();
		}
		
		
		public function flip(speed:* = Tween.NORMAL):void
		{
			var projection:PerspectiveProjection = new PerspectiveProjection();
			projection.projectionCenter = new Point(this.x, this.y);
			
			this.transform.perspectiveProjection = projection;
			
			Tween.stop(this)
				.append({rotationY: 90, z: -500, ease:Tween.EASE_IN}, speed)
				.append({scaleX:-1}, 0).call(swap)
				.append({rotationY: 180, z: 0, ease:Tween.EASE_OUT}, speed)
				.append({scaleX: 1, rotationY:0}, 0).call(resetTransformation);
		}
		
		
		public function swap():void
		{
			_flipped = !_flipped;
			_back.visible = _flipped;
			_front.visible = !_flipped;
		}
		
		
		private function resetTransformation():void
		{
			var key:String;
			var store:Object = {x:this.x, y:this.y, scaleX:this.scaleX, scaleY:this.scaleY, rotation:this.rotation};
      
			this.transform.matrix = null;
			this.transform.matrix3D = null;
			this.transform.perspectiveProjection = null;
			
			for (key in store) this[key] = store[key];
		}
		
		
		private function remove(child:DisplayObject):void
		{
			if (child && child.parent) child.parent.removeChild(child);
		}

	}
}
