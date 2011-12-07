// TODO: REFINE / MAKE CLEANER

package core.modules
{
	import core.animation.tweenlite.easing.Cubic;
	import core.api.data.ImageHandler;
	import core.display.MoveClip;
	import core.events.MoveEvent;
	import core.modules.abstract.AbstractModule;
	import core.modules.abstract.IModule;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;

	public class Carousel extends AbstractModule implements IModule
	{
		private static const BLUR_INTENSITY:Number = 15;
		private static const SHADOW_INTENSITY:Number = 12;
		private static const BLUR_QUALITY:int = 1;
		private static const SHADOW_QUALITY:int = 3;
		
		private static const RADIAN_MULTIPLY:Number = Math.PI / 180;
		private const HIDE_PERCENTAGE:Number = .2;
		
		private var _contents:Array;
		private var _container:Sprite;
		private var _move:MoveClip;
		private var _degreeStep:Number;
		private var _moveFriction:Number;
		
		private var _offset:Number;
		private var _degree:Number;
		private var _i:int;
		private var _count:int;
		private var _content:Sprite;
		private var _sorting:Array;
		private var _projection:PerspectiveProjection;
		
		override public function render():void
		{
			super.render();
			super.holder.addChild(_container);
			super.holder.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			_move.addEventListener(MoveEvent.POSITION_UPDATE, rearrange);
			_move.addEventListener(MoveEvent.MOVE_COMPLETE, clean);
			
			add(super.parameters.images);
		}
		
		
		override public function die():void
		{
			super.holder.removeEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			_move.removeEventListener(MoveEvent.POSITION_UPDATE, rearrange);
			_move.removeEventListener(MoveEvent.MOVE_COMPLETE, clean);
			
			super.die();
			
			for each (_content in _contents)
			{
				if (_content is ImageHandler) (_content as ImageHandler).unload();
				_content = null;
			}
			
			_contents = null;
		}
		
		
		public function add(content:*):void
		{
			if (content is Array) displayContent(content as Array);
			else displayContent([content]);
		}
		
		
		public function get id():int
		{
			var temp:int = Math.round((0 - _offset) / _degreeStep);
			if (temp < 0) temp += _count;
			if (temp >= _count) temp -= _count;
			return temp;
		}
		
		public function set id(value:int):void
		{
			if (value < 0) value += _count;
			if (value > _count) value -= _count;
			_move.moveTo(0 - _move.snap * value, NaN, Cubic.easeInOut);
		}
		
		
		public function next():void
		{
			this.id = this.id + 1;
			//_move.moveTo(0 - _move.snap * (Math.round((0 - _offset) / _degreeStep) + 1), NaN, Cubic.easeInOut);
		}
		
		public function prev():void
		{
			this.id = this.id - 1;
			//_move.moveTo(0 - _move.snap * (Math.round((0 - _offset) / _degreeStep) - 1), NaN, Cubic.easeInOut);
		}
		
		
		public function Carousel()
		{
			super();
			_contents = new Array();
			_container = new Sprite();
			//_container.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, .6, 2)];
			
			_move = new MoveClip();
			_move.friction.release = .5;
			_move.free = true;
		}
		
		
		
		
		private function displayContent(content:Array):void
		{
			for each (_content in content)
			{
				_content.y = _content.height*-.5;
				_content.transform.perspectiveProjection = _projection;
				
				_container.addChild(_content);
				_contents.push(_content);
			}
			
			_moveFriction = 1;
			_count = _contents.length;
			_degreeStep = (Math.PI * 2) / _count;
			_move.snap = _degreeStep * 1000 * _moveFriction;
			
			rearrange();
			clean();
		}
		
		
		private function startDrag(e:MouseEvent):void
		{
			_move.startClipDrag(e);
		}
		
		
		private function rearrange(e:MoveEvent = null):void
		{
			_offset = _move.x / (1000 * _moveFriction);
			_sorting = new Array();
			
			for (_i = 0; _i < _count; _i++)
			{
				_content = _contents[_i] as Sprite;
				
				_degree = _degreeStep * _i + _offset;
				
				_content.x = Math.sin(_degree) * width - _content.width * .5;
				_content.z = 0 - Math.cos(_degree) * width + width;
				_sorting.push(_content);
			}
			
			
			
			_sorting.sortOn('z', Array.NUMERIC);
			_sorting.reverse();
			for (_i = 0; _i < _count; _i++)
			{
				_content = _sorting[_i];
				_content.filters = [new BlurFilter((_count - 1 - _i) * BLUR_INTENSITY, (_count - 1 - _i) * BLUR_INTENSITY, BLUR_QUALITY), new DropShadowFilter(0, 0, 0, 1, (_count - _i) * SHADOW_INTENSITY, (_count - _i) * SHADOW_INTENSITY, .6, SHADOW_QUALITY)];
				_content.alpha = 1 / (_count - _i) + .5;
				if (_i > Math.floor(_count*HIDE_PERCENTAGE)) _content.visible = true;
				else _content.visible = false;
				
				_container.setChildIndex(_sorting[_i], _i);
			}
		}
		
		private function clean(e:MoveEvent = null):void
		{
			_content = _container.getChildAt(_container.numChildren - 1) as Sprite;
			_content.transform.matrix3D = null;
			_content.x = _content.width*-.5;
			_content.y = _content.height*-.5;
			_content.alpha = 1;
			_content.filters = [new DropShadowFilter(0, 0, 0, 1, SHADOW_INTENSITY, SHADOW_INTENSITY, .6, SHADOW_QUALITY)];
		}
		
		
		override protected function resize():void
		{
			_container.graphics.clear();
			_container.graphics.beginFill(0xFF0000, 0);
			_container.graphics.drawRect(width*-.5, height*-.5, width, height);
			_container.graphics.endFill();
			_container.x = width * .5;
			_container.y = height * .5;
			
			_projection = new PerspectiveProjection();
			_projection.projectionCenter = new Point(0, 0);
			_projection.fieldOfView = parameters.fov;
			
			for each (_content in _contents)
			{
				_content.transform.perspectiveProjection = _projection;
			}
		}
		
	}
}