package core.jquery
{
  import core.api.def.stage;
  import core.utils.ArrayUtils;
  
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
	
	[ExcludeClass]
  public class jQueryTraversing
  {
    public static const FIRST:String = 'first';
    public static const LAST:String = 'last';
    
    public static function find(inObject:*, what:*, returnFirst:Boolean = true):jQuery
    {
      var i:int, count:int;
      var found:*, property:*;
      var temp:DisplayObject;
      var list:Array = new Array();
      var returnWhat:String;
      
      if (returnFirst && (what is String))
      {
        if (what.indexOf(':') > 0)
        {
          var args:Array = what.split(':');
          what = String(args[0]);
          returnWhat = String(args[1]);
          if (returnWhat.toLowerCase() != FIRST) returnFirst = false;
        }
      }
      
      
      try
      {
        // fetch property
        if (inObject[what])
        {
          if (returnFirst) return new jQuery(inObject[what]);
          else list.push(inObject[what]);
        }
        
        // fetch children
        if (inObject.hasOwnProperty('getChildByName'))
        {
          count = inObject.numChildren;
          
          if (inObject.getChildByName(String(what)))
          {
            temp = inObject.getChildByName(String(what));
            if (returnFirst) return new jQuery(temp);
            else list.push(temp);
          }
          
          else for (i = 0; i < count; i++)
          {
            temp = inObject.getChildAt(i);
            if (temp == what)
            {
              if (returnFirst) return new jQuery(temp);
              else list.push(found);
            }
            
            found = find(temp, what);
            if (found != null)
            {
              if (returnFirst) return new jQuery(found);
              else list.push(found);
            }
          }
        }
        else
        {
          // fetch in properties
          for each (property in inObject)
          {
            found = find(property, what);
            if (found != null)
            {
              if (returnFirst) return new jQuery(found);
              else list.push(found);
            }
          }
        }
      }
      catch(e:Error)
      {
        trace(e);
        return new jQuery(null);
      }
      
      list = ArrayUtils.removeDuplicateArrayElements(list);
      
      return new jQuery(list);
      return new jQuery(null);
    }
    
    
    public static function wrap(target:*, object:Sprite):void
    {
      if (target.hasOwnProperty('parent'))
      {
        if (object == null) object = new Sprite();
        var parentObj:DisplayObjectContainer = parent(target);
        if (parentObj) parentObj.removeChild(DisplayObject(target));
				
				parentObj = parent(parentObj);
        if (parentObj && !(object == parentObj || target == object || target == parentObj)) parentObj.addChild(DisplayObject(object));
				object.addChild(target);
      }
    }
    
    public static function unwrap(target:*):void
    {
      if (target.hasOwnProperty('parent'))
      {
        var parent:DisplayObjectContainer = parent(target);
        if (parent) parent.removeChild(DisplayObject(target));
        if (parent.parent) parent.parent.addChild(DisplayObject(target));
      }
    }
    
    
    private static function parent(target:*):DisplayObjectContainer
    {
      if (target.hasOwnProperty('parent') && DisplayObject(target).parent)
      {
        return DisplayObjectContainer(DisplayObject(target).parent);
      }
      
      return null;
    }
    
  }
}