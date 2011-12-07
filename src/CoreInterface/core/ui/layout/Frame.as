package core.ui.layout
{
  import core.ui.controls.abstract.AbstractControl;
  import core.ui.controls.ScrollBar;
  
  import flash.display.DisplayObject;
  import flash.display.Sprite;

  public class Frame extends Sprite
  {
    private var _scrollbar:ScrollBar;
    private var _content:DisplayObject;
    private var _reference:DisplayObject;
    
    public function set content(value:Sprite):void
    {
      _scrollbar.target = value;
    }
    
    public function set match(value:DisplayObject):void
    {
      _scrollbar.match = value;
    }
    
    
    
    public function Frame()
    {
      super();
      
      _scrollbar = new ScrollBar();
      this.addChild(_scrollbar);
    }
  }
}