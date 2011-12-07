package core.ui.controls.base
{
  import core.display.MoveClip;
  import core.events.MoveEvent;
  import core.ui.Label;
  
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  public class Roller extends Sprite
  {
		private const SHOW_ITEMS:int = 3;
		
    private var _list:Array;
    private var _ref:MoveClip;
		private var _holder:Sprite;
		private var _container:Sprite;
		private var _mask:Sprite;
		
		private var _labelHeight:int;
		private var _delta:Number;
		private var _width:Number;
		private var _height:Number;
		
		private var _id:Number;
		
		private var _posY:Number;
		private var _difference:Number;
		
		// HELPER
    private var _currentID:int;
		private var _first:Label;
		private var _last:Label;
		private var _itemLength:int;
		private var _swapBounds:int;
		private var _tempItem:Label;
		private var _counter:int;
		
		public function setBounds(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			_delta = (_height - _labelHeight) / SHOW_ITEMS;
			_swapBounds = _delta * SHOW_ITEMS;
			
			_container.y = _height / 2;
			
			_ref.snap = _delta;
			
      redraw();
			redrawMask();
		}
		
		public function get id():int { return _id; }
		public function set id(value:int):void
		{
			var difference:int = (value - _id);
			
			_posY = _ref.y;
			_ref.moveTo(0, 0 - _delta * difference);
		}
		
		public function set list(value:Array):void
		{
			_list = value;
			_itemLength = _list.length;
			redraw();
		}
		
    public function Roller():void
		{
			super();
			
			_width = 1;
			_height = 1;
			
			var temp:Label = new Label('Temporary', 'Roller');
			_labelHeight = Math.ceil(temp.height);
			_delta = 1;
			
			
			_list = new Array();
			_holder = new Sprite();
			_container = new Sprite();
			_mask = new Sprite();
			
			_container.addChild(_holder);
			_container.mask = _mask;
			
			this.addChild(_container);
			this.addChild(_mask);
			
      
      _ref = new MoveClip();
      _ref.friction.release = .88;
      _ref.free = true;
		}
		
		
		public function construct():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, startRoller);
      _ref.addEventListener(MoveEvent.POSITION_UPDATE, moveHolder);
      _ref.addEventListener(MoveEvent.MOVE_COMPLETE, resetPosition);
		}
		
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, startRoller);
      _ref.removeEventListener(MoveEvent.POSITION_UPDATE, moveHolder);
      _ref.removeEventListener(MoveEvent.MOVE_COMPLETE, resetPosition);
		}
		
		
		
		
		private function startRoller(event:MouseEvent):void
		{
			//_holder.y = Math.round(_holder.y * _delta) / _delta;
			//_holder.y = Math.round(_holder.y * (_labelHeight / 2)) / (_labelHeight / 2);
      
      _ref.y = 0;
      _posY = _ref.y;
      _holder.y = Math.round(_holder.y / _delta) * _delta;
      
      _ref.startClipDrag(event);
		}
		
		private function resetPosition(event:MoveEvent):void
		{
			_ref.x = 0;
			_ref.y = 0;
			//trace(_holder.y);
			_holder.y = Math.round(_holder.y / _delta) * _delta;
			//trace(_holder.y);
			//trace('delta: ' + _delta);
			
			//_holder.y = Math.round(_holder.y * (_labelHeight / 2)) / (_labelHeight / 2);
			
			if (_id < 0) _id += _itemLength;
			if (_id >= _itemLength) _id -= _itemLength;
			
		}
		
    private function moveHolder(event:MoveEvent = null):void
		{
			_difference = (_ref.y - _posY);
			_posY = _ref.y;
			_holder.y += _difference;
			rearrange();
		}
		
		
		
		
		private function redraw():void
		{
			while(_holder.numChildren > 0) _holder.removeChildAt(0);
			
			var item:String;
			var field:Label;
			var half:int = Math.floor(_itemLength / 2);
			var i:int;
			var fields:Array = new Array();
			
			for (i = 0; i < _itemLength; i++)
			{
				item = String(_list[i]);
				field = new Label(item, 'Roller');
				_holder.addChild(field);
				fields.push(field);
			}
			
			for (i = 0; i < _itemLength; i++)
			{
				field = Label(fields[i]);
				
				if (i == 0) _first = field;
				
				if (i < half)
				{
					field.y = (_delta) * i;
				}
				else {
					field.y = 0 - (_delta) * (_itemLength - i);
					field.parent.setChildIndex(field,  i - half);
				}
				
				_last = field;
				field.y = field.y - _labelHeight / 2;
			}
			
			rearrange();
			_id = 0;
		}
		
		
		private function redrawMask():void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFF0000, 1);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			
			_holder.graphics.clear();
			_holder.graphics.beginFill(0xFF0000, 0.0);
			_holder.graphics.drawRect(0, -_height * 4, _width, _height * 8);
			_holder.graphics.endFill();
		}
		
		
		
		
		
		
    private function rearrange():void
    { 
			while (_holder.y > (0 - _swapBounds))
			{
				_id--;
				_tempItem = Label(_holder.getChildAt(_itemLength - 1));
				
				_first = _tempItem;
				
				_tempItem.y = (_holder.getChildAt(0).y - _delta);
				_holder.setChildIndex(_tempItem, 0);
				
				for (_counter = 0; _counter < _itemLength; _counter++)
				{
					_holder.getChildAt(_counter).y += _delta;
				}
				
				_holder.y -= _delta;
			}
			
			while (_holder.y < (0 - _swapBounds))
			{
				_id++;
				_tempItem = Label(_holder.getChildAt(0));
				
				_last = _tempItem;
				
				_tempItem.y = (_holder.getChildAt(_itemLength - 1).y + _delta);
				_holder.setChildIndex(_tempItem, _itemLength - 1);
				
				for (_counter = 0; _counter < _itemLength; _counter++)
				{
					_holder.getChildAt(_counter).y -= _delta;
				}
				_holder.y += _delta;
			}
      
    }
    
    
  }
}
