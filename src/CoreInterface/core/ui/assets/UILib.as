package core.ui.assets
{
  import core.api.Lib;
  
  import flash.utils.Dictionary;
  
  [ExcludeClass] public class UILib
  {
		UILib.init();
		
    private static var _assets:Dictionary;
		
    public static function init():void
    {
      if (_assets != null) return;
      
      insertAssets();
      Lib.extend(_assets);
    }
    
    
    private static function insertAssets():void
    {
      _assets = new Dictionary();
      
			// Activity
			[Embed(source="/lib/ui/activity/activity.png")]       var activity:Class;
			_assets['ui/activity/activity']                         = activity;
			
			
			
      // Checkbox
      [Embed(source="/lib/ui/checkbox/checkbox.off.png")]       var checkboxOff:Class;
      [Embed(source="/lib/ui/checkbox/checkbox.on.png")]        var checkboxOn:Class;
      
      _assets['ui/checkbox/checkbox.off']    = checkboxOff;
      _assets['ui/checkbox/checkbox.on']     = checkboxOn;
      
      
      // RADIO
      [Embed(source="/lib/ui/radio/radio.off.png")]             var radioOff:Class;
      [Embed(source="/lib/ui/radio/radio.on.png")]              var radioOn:Class;
      
      _assets['ui/radio/radio.off']          = radioOff;
      _assets['ui/radio/radio.on']           = radioOn;
      
      
      
      // SWITCHER
      [Embed(source="/lib/ui/switcher/switcher.off.png")]       var switcherOff:Class;
      [Embed(source="/lib/ui/switcher/switcher.on.png")]        var switcherOn:Class;
      [Embed(source="/lib/ui/switcher/switcher.handle.png")]    var switcherHandle:Class;
      
      _assets['ui/switcher/switcher.off']    = switcherOff;
      _assets['ui/switcher/switcher.on']     = switcherOn;
      _assets['ui/switcher/switcher.handle'] = switcherHandle;
      
      
      
      // SLIDER
      [Embed(source="/lib/ui/slider/slider.background.left.png")]   var sliderBackgroundLeft:Class;
      [Embed(source="/lib/ui/slider/slider.background.right.png")]  var sliderBackgroundRight:Class;
      [Embed(source="/lib/ui/slider/slider.background.fill.png")]   var sliderBackgroundFill:Class;
      [Embed(source="/lib/ui/slider/slider.background.empty.png")]  var sliderBackgroundEmpty:Class;
      [Embed(source="/lib/ui/slider/slider.handle.png")]            var sliderHandle:Class;
      
      _assets['ui/slider/slider.background.left']   = sliderBackgroundLeft;
      _assets['ui/slider/slider.background.right']  = sliderBackgroundRight;
      _assets['ui/slider/slider.background.fill']   = sliderBackgroundFill;
      _assets['ui/slider/slider.background.empty']  = sliderBackgroundEmpty;
      _assets['ui/slider/slider.handle']            = sliderHandle;
      
      
      
      // SCROLLBAR
      [Embed(source="/lib/ui/scrollbar/scrollbar.background.png")]        var scrollbarBackground:Class;
      [Embed(source="/lib/ui/scrollbar/scrollbar.arrow.png")]             var scrollbarArrow:Class;
      [Embed(source="/lib/ui/scrollbar/scrollbar.arrow.active.png")]      var scrollbarArrowActive:Class;
      [Embed(source="/lib/ui/scrollbar/scrollbar.handle.png")]            var scrollbarHandle:Class;
      [Embed(source="/lib/ui/scrollbar/scrollbar.handle.background.png")] var scrollbarHandleBackground:Class;
      [Embed(source="/lib/ui/scrollbar/scrollbar.handle.top.png")]        var scrollbarHandleTop:Class;
      
      _assets['ui/scrollbar/scrollbar.background']        = scrollbarBackground;
      _assets['ui/scrollbar/scrollbar.arrow']             = scrollbarArrow;
      _assets['ui/scrollbar/scrollbar.arrow.active']      = scrollbarArrowActive;
      _assets['ui/scrollbar/scrollbar.handle']            = scrollbarHandle;
      _assets['ui/scrollbar/scrollbar.handle.background'] = scrollbarHandleBackground;
      _assets['ui/scrollbar/scrollbar.handle.top']        = scrollbarHandleTop;
      
      
      
      // TAB
      [Embed(source="/lib/ui/tab/tab.active.left.png")]   var tabActiveLeft:Class;
      [Embed(source="/lib/ui/tab/tab.active.png")]        var tabActive:Class;
      [Embed(source="/lib/ui/tab/tab.inactive.left.png")] var tabInactiveLeft:Class;
      [Embed(source="/lib/ui/tab/tab.inactive.png")]      var tabInactive:Class;
      [Embed(source="/lib/ui/tab/tab.shadow.left.png")]   var tabShadowLeft:Class;
      
      _assets['ui/tab/tab.active.left']    = tabActiveLeft;
      _assets['ui/tab/tab.active']         = tabActive;
      _assets['ui/tab/tab.inactive.left']  = tabInactiveLeft;
      _assets['ui/tab/tab.inactive']       = tabInactive;
      _assets['ui/tab/tab.shadow.left']    = tabShadowLeft;
      
      
      
      // PICKER
      [Embed(source="/lib/ui/picker/picker.background.png")]   var pickerBackground:Class;
      [Embed(source="/lib/ui/picker/picker.bar.png")]          var pickerBar:Class;
      [Embed(source="/lib/ui/picker/picker.left.png")]         var pickerLeft:Class;
      [Embed(source="/lib/ui/picker/picker.content.png")]      var pickerContent:Class;
      [Embed(source="/lib/ui/picker/picker.shadow.png")]       var pickerShadow:Class;
      [Embed(source="/lib/ui/picker/picker.separator.png")]    var pickerSeparator:Class;
      
      _assets['ui/picker/picker.background']    = pickerBackground;
      _assets['ui/picker/picker.bar']           = pickerBar;
      _assets['ui/picker/picker.left']          = pickerLeft;
      _assets['ui/picker/picker.content']       = pickerContent;
      _assets['ui/picker/picker.shadow']        = pickerShadow;
      _assets['ui/picker/picker.separator']     = pickerSeparator;
      
      
      
      // DOCK
      [Embed(source="/lib/ui/dock/dock.background.png")]        var dockBackground:Class;
      
      _assets['ui/dock/dock.background']     = dockBackground;
      
      
      
      // ALERT
      [Embed(source="/lib/ui/alert/alert.background.png")]      var alertBackground:Class;
      [Embed(source="/lib/ui/alert/alert.button.png")]          var alertButton:Class;
      [Embed(source="/lib/ui/alert/alert.button.off.png")]      var alertButtonOff:Class;
      [Embed(source="/lib/ui/alert/alert.bottom.png")]          var alertBottom:Class;
      [Embed(source="/lib/ui/alert/alert.bottom.left.png")]     var alertBottomLeft:Class;
      [Embed(source="/lib/ui/alert/alert.left.png")]            var alertLeft:Class;
      [Embed(source="/lib/ui/alert/alert.top.png")]             var alertTop:Class;
      [Embed(source="/lib/ui/alert/alert.top.left.png")]        var alertTopLeft:Class;
      
      _assets['ui/alert/alert.background']  = alertBackground;
      _assets['ui/alert/alert.button']      = alertButton;
      _assets['ui/alert/alert.button.off']  = alertButtonOff;
      _assets['ui/alert/alert.bottom']      = alertBottom;
      _assets['ui/alert/alert.bottom.left'] = alertBottomLeft;
      _assets['ui/alert/alert.left']        = alertLeft;
      _assets['ui/alert/alert.top']         = alertTop;
      _assets['ui/alert/alert.top.left']    = alertTopLeft;
    }
  }
}