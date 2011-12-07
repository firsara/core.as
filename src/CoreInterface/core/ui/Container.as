package core.ui
{
	import core.Core;
	import core.ui.Alert;
	import core.ui.UI;
	import core.ui.controls.ScrollBar;
	import core.ui.layout.Box;
	import core.ui.layout.VBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Container extends VBox
	{
		private var _sb:ScrollBar;
		
		public function Container()
		{
			super();
			if (!Core.ready) Core.init(this, initUI);
			else initUI();
		}
		
		private function initUI():void
		{
			if (!UI.ready) UI.init(this, construct);
			else construct();
		}
		
		private function construct():void
		{
			_sb = new ScrollBar();
			this.stage.addChild(_sb);
			
			_sb.target = this;
			_sb.match = this.stage;
			
			this.stage.addEventListener(Event.RESIZE, resized);
		}
		
		private function resized(e:Event):void
		{
			_sb.x = this.stage.stageWidth - _sb.width;
		}
		
	}
}
