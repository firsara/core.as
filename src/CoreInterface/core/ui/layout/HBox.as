package core.ui.layout
{
	public class HBox extends Box implements ILayout
	{
		public function HBox()
		{
			super();
		}
		
		override protected function calculateSpacing():void
		{
			_spaceHeight = (this.height - this._maxChildHeight);
		}
		
		override protected function rearrange():void
		{
			if (this.numChildren == 0) return;
			
			_child = this.getChildAt(0);
			_child.x = this.padding;
			if (this.horizontalSpreadType == LayoutSpreadType.HORIZONTAL_CENTER) _child.x += _spaceWidth;
			
			for (_counter = 0; _counter < _numChildren - 1; _counter++)
			{
				_child = this.getChildAt(_counter+1);
				_child.x = this.getChildAt(_counter).x + this.getChildAt(_counter).width + this.padding;
				
				if      (this.horizontalSpreadType == LayoutSpreadType.HORIZONTAL_CENTER) _child.x += _spaceWidth;
				else if (this.horizontalSpreadType == LayoutSpreadType.HORIZONTAL_RIGHT) _child.x += (this.width - _childWidth - _child.width);
				
				if      (this.verticalSpreadType == LayoutSpreadType.VERTICAL_CENTER) _child.y = (this._maxChildHeight - _child.height) / 2;
				else if (this.verticalSpreadType == LayoutSpreadType.VERTICAL_BOTTOM) _child.y = (this._maxChildHeight - _child.height);
			}
		}
		
	}
}