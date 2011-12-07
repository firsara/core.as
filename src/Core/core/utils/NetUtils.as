package core.utils
{
	import core.api.Config;
	import core.api.def.main;
	
	import flash.display.Loader;
	
	public final class NetUtils
	{
		public static function get runsLocal():Boolean
		{
			if (!core.api.def.main) return true;
			return (core.api.def.main.loaderInfo.url.indexOf("file:") != -1);
			//_runsLocal = (Capabilities.playerType == "External");
		}
		
		public static function recache(url:String):String
		{
			if (!runsLocal && Config.instance.cache == false)
			{
				if(url.indexOf('?') >= 0)
				     return (url + '&' + new Date().getTime());
				else return (url + '?' + new Date().getTime());
			}
			
			return url;
		}
		
		public static function unload(loader:Loader):void
		{
			try { loader['unloadAndStop'](true); }
			catch (e:Error) { loader.unload(); }
		}
	}
}