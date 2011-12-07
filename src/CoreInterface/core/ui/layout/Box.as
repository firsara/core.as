package core.ui.layout
{
	import core.actions.monitorClip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Box extends Sprite implements ILayout
	{
		private var _padding:Number;
		private var _horizontalSpreadType:String;
		private var _verticalSpreadType:String;
		
		
		protected var _child:DisplayObject;
		
		protected var _counter:int;
		protected var _numChildren:int;
		protected var _childWidth:Number;
		protected var _childHeight:Number;
		protected var _spaceWidth:Number;
		protected var _spaceHeight:Number;
		
		protected var _maxChildWidth:Number;
		protected var _maxChildHeight:Number;
		
		
		public final function get padding():Number { return _padding; }
		public final function set padding(value:Number):void
		{
			_padding = value;
			if (this.numChildren > 0) rearrange();
		}
		
		public final function get horizontalSpreadType():String { return _horizontalSpreadType; }
		public final function set horizontalSpreadType(value:String):void
		{
			_horizontalSpreadType = value;
			if (this.numChildren > 0) rearrange();
		}
		
		
		public final function get verticalSpreadType():String { return _verticalSpreadType; }
		public final function set verticalSpreadType(value:String):void
		{
			_verticalSpreadType = value;
			if (this.numChildren > 0) rearrange();
		}
		
		
		private function updateDisplayList():void
		{
			_numChildren = this.numChildren;
			_childWidth = 0;
			_childHeight = 0;
			_maxChildWidth = 0;
			_maxChildHeight = 0;
			
			for (_counter = 0; _counter < numChildren; _counter++)
			{
				_child = this.getChildAt(_counter);
				_child.x = 0;
				_child.y = 0;
				_childWidth += _child.width;
				_childHeight += _child.height;
				
				_maxChildWidth = Math.max(_child.width, _maxChildWidth);
				_maxChildHeight = Math.max(_child.height, _maxChildHeight);
				
				core.actions.unmonitorClip(_child);
				core.actions.monitorClip(_child, null, rearrange);
			}
			
			rearrange();
		}
		
		private function boxResized():void
		{
			_spaceWidth = (this.width - _childWidth - (_padding * (_numChildren-1))) / (_numChildren);
			_spaceHeight = (this.height - _childHeight - (_padding * (_numChildren-1))) / (_numChildren);
			calculateSpacing();
			rearrange();
		}
		
		
		
		protected function calculateSpacing():void
		{
		}
		
		protected function rearrange():void
		{
		}
		
		
		
		public function Box()
		{
			super();
			_padding = 0;
			core.actions.monitorClip(this, null, boxResized, updateDisplayList);
		}
	}
}