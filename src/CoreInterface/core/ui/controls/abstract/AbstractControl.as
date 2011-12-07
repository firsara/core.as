package core.ui.controls.abstract
{
  import core.Core;
  import core.api.def.stage;
  import core.events.CoreEvent;
  import core.ui.UI;
  import core.ui.assets.UIAssets;
  import core.ui.events.UIEvent;
  
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;
  
  public class AbstractControl extends Sprite implements IAbstractControl
  {
    private var _ready:Boolean;
    
    public function get ready():Boolean       { return _ready; }
    
		
    public function tint():void
		{
			throw new Error('tinting not overridden');
		}
    
		
		public override function set width(value:Number):void
		{
			throw new Error('set width not overridden');
		}
		
		
		public function construct():void
		{
			// MAIN CONTROL CONSTRUCTION - OVERRIDEN
			
			
			// REGISTERS EVENTS
			
			throw new Error('construct not overridden by child-class');
		}
		
		public function dispose():void
		{
			// MAIN CONTROL CONSTRUCTION - OVERRIDEN
			
			// UNREGISTERS EVENTS
			
			throw new Error('dispose not overridden by child-class');
		}
		
		
		public function draw():void
		{
			// MAIN CONTROL drawing
			
			throw new Error('draw not overridden by child-class');
		}
		
    
    
    public function AbstractControl()
    {
      super();
			
			if (!UIAssets.ready) UIAssets.init();
			while(this.numChildren > 0) this.removeChildAt(0);
			
			draw();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
      if (core.api.def.stage) addedToStage();
      else this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }
		
		
		private function retint(e:UIEvent = null):void
		{
			tint();
		}
    
    
    
		private function removedFromStage(event:Event = null):void
		{
			UI.instance.removeEventListener(UIEvent.CHANGE_DEFINITIONS, retint);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			dispose();
		}
    
    
    private function addedToStage(event:Event = null):void
    {
      if (event) this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.INIT, controlReady);
			else controlReady();
    }
		
    
    
    private function controlReady(event:Event = null):void
    {
      if (event) event.currentTarget.removeEventListener(Event.INIT, controlReady);
			if (!core.api.def.stage) core.api.def.stage = this.stage;
			if (!UI.instance) UI.init(core.api.def.stage);
			UI.instance.addEventListener(UIEvent.CHANGE_DEFINITIONS, retint);
			initializeControl();
    }
    
    
    private function initializeControl(event:CoreEvent = null):void
    {
      while(this.numChildren > 0) this.removeChildAt(0);
			draw();
			tint();
      construct();
			_ready = true;
    }
    
    
  }
}
