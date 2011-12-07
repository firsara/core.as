package core.api
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	[ExcludeClass]
	final public class Classes
  {
		private static var _instance:Classes;
		
		public static function get instance():Classes
		{
			if (!_instance) _instance = new Classes();
			return _instance;
		}
		
		public function get(className:String, domain:ApplicationDomain = null):Class
		{
      if (domain == null) domain = ApplicationDomain.currentDomain;
			if (!domain.hasDefinition(className)) return (undefined as Class);
			return domain.getDefinition(className) as Class;
		}
    
    public function getDisplayObject(className:String, domain:ApplicationDomain = null, assignName:String = ''):DisplayObject
    {
      var Reference:Class = this.get(className, domain);
      var object:*;
      
      if (Reference == null)
      {
        throw new Error(className + ' not found in current ClassPath');
        object = new Sprite();
      }
      else
      {
        object = new Reference();
      }
      
      try {
        object = new Bitmap(object);
        object.smoothing = true;
      } catch(e:Error){}
      
      if (assignName != '') object.name = assignName;
      
      return (object as DisplayObject);
    }
    
	}
}
