package core.ui.layout
{
	import core.actions.snap;
	
	public class VBox extends Box implements ILayout
	{
		public function VBox()
		{
			super();
		}
		
		override protected function calculateSpacing():void
		{
			_spaceWidth = (this.width - this._maxChildWidth);
		}
		
		override protected function rearrange():void
		{
			if (this.numChildren == 0) return;
			_numChildren = this.numChildren;
			
			_child = this.getChildAt(0);
			_child.y = this.padding;
			if (this.verticalSpreadType == LayoutSpreadType.VERTICAL_CENTER) _child.y += _spaceHeight;
			
			for (_counter = 0; _counter < _numChildren - 1; _counter++)
			{
				_child = this.getChildAt(_counter+1);
				_child.y = this.getChildAt(_counter).y + this.getChildAt(_counter).height + this.padding;
				
				if      (this.horizontalSpreadType == LayoutSpreadType.HORIZONTAL_CENTER) _child.x = (this._maxChildWidth - _child.width) / 2;
				else if (this.horizontalSpreadType == LayoutSpreadType.HORIZONTAL_RIGHT) _child.x = (this._maxChildWidth - _child.width);
				
				if      (this.verticalSpreadType == LayoutSpreadType.VERTICAL_CENTER) _child.y += _spaceHeight;
				else if (this.verticalSpreadType == LayoutSpreadType.VERTICAL_BOTTOM) _child.y += (this.height - _childHeight - _child.height);
				
				core.actions.snap(this.getChildAt(_counter));
			}
		}
		
	}
}