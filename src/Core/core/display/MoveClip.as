// core.display.MoveClip
// author: Fabian Irsara

package core.display
{
	import core.animation.Tween;
	import core.animation.tweenlite.easing.Cubic;
	import core.api.app.InputHandler;
	import core.api.def.stage;
	import core.events.InputEvent;
	import core.events.MoveEvent;
	import core.settings.InputSetup;
	import core.vars.MoveClipBorders;
	import core.vars.MoveClipFriction;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public dynamic class MoveClip extends MovieClip
	{
		public static var STACK_MOVE:int = 2;
		
		protected var _properties:Object;
		protected var _store:Object;
		
		private var _borders:MoveClipBorders;
		private var _friction:MoveClipFriction;
		
		private var _adjustContainerIndex:Boolean = false;
		private var _locked:Boolean;
		private var _freeMove:Boolean;
		private var _moveStep:Number;
		
		
		public function MoveClip()
		{
			this.cacheAsBitmap = true;
			try { this.cacheAsBitmapMatrix = new Matrix(); } catch(e:Error) {}
			
			_borders = new MoveClipBorders();
			_friction = new MoveClipFriction();
			_store = new Object();
			_properties = new Object();
			_moveStep = 0;
			
			if (this.stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		// MOVE STEP
		public function get snap()  :Number { return _moveStep; }
		public function set snap(val:Number):void
		{
			_moveStep = val;
			this.x = (Math.round(this.x / _moveStep) * _moveStep);
			this.y = (Math.round(this.y / _moveStep) * _moveStep);
		}
		
		
		// BORDERS
		public function get borders()    :MoveClipBorders { return _borders; }
		public function set borders(value:MoveClipBorders):void
		{
			_borders = value;
			holdBorders();
		}
		
		
		// FRICTION
		public function get friction()    :MoveClipFriction { return _friction; }
		public function set friction(value:MoveClipFriction):void
		{
			_friction = value;
			holdBorders();
		}
		
		
		// FREE MOVING
		public function get free()  :Boolean { return _freeMove; }
		public function set free(val:Boolean):void
		{
			_freeMove = val;
			
			if (val == false)
			{
        _borders.x[0] = this.x;
        _borders.x[1] = this.x;
        
        _borders.y[0] = this.y;
        _borders.y[1] = this.y;
			}
		}
		
		
		// LOCK
		public function get lock()  :Boolean { return _locked }
		public function set lock(val:Boolean):void
		{
			_locked = val;
			
			if (val == true)
			{
				Tween.stop(this);
				clearEvents();
			}
			else init();
		}
		
		
		// LEVEL
		public function get level()  :Boolean { return _adjustContainerIndex; }
		public function set level(val:Boolean):void
		{
			_adjustContainerIndex = val;
		}
		
		
		public function holdBorders():void
		{
			if (_locked) return;
			
			if      (this.x < _borders.x[0]) this.x = _borders.x[0];
			else if (this.x > _borders.x[1]) this.x = _borders.x[1];
			
			if      (this.y < _borders.y[0]) this.y = _borders.y[0];
			else if (this.y > _borders.y[1]) this.y = _borders.y[1];
		}
		
		
		
		
		public function moveTo(x:Number = NaN, y:Number = NaN, ease:* = null):void
		{
			var tween:Object = {};
			var speed:Number = 0.45 + .01 * _friction.release;
			
			if(!isNaN(x)) tween.x = x;
			if(!isNaN(y)) tween.y = y;
			if(ease) tween.ease = ease;
			else tween.ease = Cubic.easeOut;
			tween.onComplete = dispatchComplete;
			tween.onUpdate = slide;
			
			Tween.start(this).append(tween, speed);
		}
		
		
		public function startClipDrag(event:*):void
		{
			_store.move = new Array();
			
			if (isTouch(event))
			{
				var point:Object = InputHandler.getTouchPoint(event);
				_store.position = new Point(point.x, point.y);
			}
			else _store.position = new Point(core.api.def.stage.mouseX, core.api.def.stage.mouseY);
			
			Tween.stop(this);
			
			if (_adjustContainerIndex && this.parent) this.parent.setChildIndex(this, this.parent.numChildren - 1);
			
			core.api.def.stage.addEventListener(InputEvent.INPUT_UP, stopClipDrag);
			
			if (isTouch(event))
				   this.addEventListener(Event.ENTER_FRAME, updateTouch);
			else this.addEventListener(Event.ENTER_FRAME, updateMouse);
		}

		
		
		
		
		
		private function init(event:Event = null):void
		{
			if (!_borders.x)           _borders.x = [this.x, this.x];
			if (!_borders.y)           _borders.y = [this.y, this.y];
			if (!_friction.move)       _friction.move = 1;
			if (!_friction.release)    _friction.release = 1;
			
			if (!core.api.def.stage) core.api.def.stage = this.stage;
			this.removeEventListener(InputEvent.INPUT_CLICK, clicked);
			clearEvents();
			
			_store.clickCount = 0;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			this.addEventListener(InputEvent.INPUT_DOWN, startClipDrag);
			this.addEventListener(InputEvent.INPUT_CLICK, clicked);
		}
		
		private function clearEvents():void
		{
			this.removeEventListener(InputEvent.INPUT_DOWN, startClipDrag);
			this.removeEventListener(Event.ENTER_FRAME, updateTouch);
			this.removeEventListener(Event.ENTER_FRAME, updateMouse);
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			if (core.api.def.stage) core.api.def.stage.removeEventListener(InputEvent.INPUT_UP, stopClipDrag);
		}
		
		private function dispose(event:Event):void
		{
			this.removeEventListener(InputEvent.INPUT_CLICK, clicked);
			clearEvents();
		}
		
		private function resetClicks():void { _store.clickCount = 0; }
		private function clicked(event:Event):void
		{
			_store.clickCount++;
			//if (_store.clickCount == 2) this.dispatchEvent(new InputEvent(InputEvent.DOUBLE_CLICK));
			if (_store.clickCount == 2) this.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
			
			clearTimeout(_store.timeout);
			_store.timeout = setTimeout(resetClicks, InputSetup.clickMaxTime);
		}
		
		
		private function stopClipDrag(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateTouch);
			this.removeEventListener(Event.ENTER_FRAME, updateMouse);
			core.api.def.stage.removeEventListener(InputEvent.INPUT_UP, stopClipDrag);
			
			if (_locked) return;
			
			if (_store.move.length == 0) return;
			
			var speed:Number;
			var tween:Object = {};
			var average:Point = new Point(0, 0);
			var newPosition:Point = new Point();
			
			for (var i:int = 0; i < _store.move.length; i++) {
				average.x += _store.move[i].x;
				average.y += _store.move[i].y;
			}
			average.x /= _store.move.length;
			average.y /= _store.move.length;
			
			
			speed = 0.6 + .01 * Math.abs((average.x + average.y) / 2) * 2 * (_friction.release + _friction.release) / 4;
			newPosition.x = this.x + average.x * Math.max(10, Math.abs(average.x / 10)) * _friction.release / 2;
			newPosition.y = this.y + average.y * Math.max(10, Math.abs(average.y / 10)) * _friction.release / 2;
			
			if (_moveStep != 0)
			{
				newPosition.x = (Math.round(newPosition.x / _moveStep) * _moveStep);
				newPosition.y = (Math.round(newPosition.y / _moveStep) * _moveStep);
			}
			
			tween.x = newPosition.x;
			tween.y = newPosition.y;
			tween.ease = Cubic.easeOut;
			tween.onComplete = dispatchComplete;
			tween.onUpdate = slide;
			
			Tween.start(this).append(tween, speed);
			
			dispatchEvent(new MoveEvent(MoveEvent.STOPPED_DRAG));
		}
		
		
		private function updateMouse(event:Event = null):void
		{
			if (_locked) return;
			update(core.api.def.stage.mouseX, core.api.def.stage.mouseY);
		}
		
		private function updateTouch(event:Event = null):void
		{
			if (_locked) return;
			var point:Object = InputHandler.points[_store.id];
			update(point.x, point.y);
		}
		
		
		// MOVE ITEM
		private function update(xpos:Number, ypos:Number):void
		{
			if (_locked) return;
			
			var distance:Point = new Point(xpos - _store.position.x, ypos - _store.position.y);
			
			this.x += (distance.x * _friction.move);
			this.y += (distance.y * _friction.move);
			
			_store.position = new Point(xpos, ypos);
			_store.move.push(distance);
			if (_store.move.length > STACK_MOVE) _store.move.shift();
			
			slide();
		}
		
		
		private function slide():void
		{
			if (!_freeMove) holdBorders();
			dispatchUpdate();
		}
		
		
		private function dispatchUpdate():void   { dispatchEvent(new MoveEvent(MoveEvent.POSITION_UPDATE)); }
		private function dispatchComplete():void { dispatchEvent(new MoveEvent(MoveEvent.MOVE_COMPLETE)); }
		
	}
	
}
