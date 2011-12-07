package core.ui.assets
{
  [ExcludeClass] public class UIAssets 
  {
    static private var _ready     :Boolean;
    
    public static function get ready():Boolean { return _ready; }
    
    
    public static function init():void
    {
      UIFonts.init();
      UILib.init();
      _ready = true;
    }
    
  }
}
