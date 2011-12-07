package core.net
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public final class Session
	{
		private var $_SESSION:Dictionary;
		
		public function get(key:String):String
		{
			if (!$_SESSION[key]) return "";
			return $_SESSION[key];
		}
		
		public function set(key:String, value:String):void
		{
			$_SESSION[key] = value;
		}
    
    
    
    public function clear():void
    {
			$_SESSION = new Dictionary();
    }
    
    public function Session()
    {
			$_SESSION = new Dictionary();
    }
		
		
	}
}
