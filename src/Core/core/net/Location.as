package core.net
{
	import core.actions.log;
	import core.api.Config;
	import core.events.LocationEvent;
	import core.utils.NetUtils;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	public class Location extends EventDispatcher
	{
		include '../_inc_/StaticRequire.as';
		private static var         _instance :Location;
		public static function get instance():Location { return _instance; }
		
		private static const DELIMETER:String = "/";
		private static const BEGINNING:String = "/";
		
		private static var _url:Array;
		private static var _keys:Array;
		private static var _default:Array;
		
		private static var _recheckTime:Number = 75;
		private static var _recheckWait:Number = 250;
		private var _recheckInterval:uint;
		private var _location:String;
    private var _queryString:String;
    private var _query:Query;
		private var _session:Session;
		
				
		public function get query():Query { return _query; }
		public function get session():Session { return _session; }
    public function get available():Boolean { return Location.available; }
    public function alert(value:String):void { Location.alert(value); }
    public function log(value:String):void { Location.log(value); }
    public function debug(value:String):void { Location.debug(value); }
    
    
		public function Location()
		{
			include '../_inc_/StaticRequireValidation.as';
			_instance = this;
			
      _queryString = "";
			_url = new Array();
			_keys = new Array();
			_default = new Array();
      _query = new Query();
			_session = new Session();
      
      //_query.addEventListener(LocationEvent.QUERY_CHANGE, updateQuery);
			
			restartInterval();
		}
		
		
    
    
    
		public static function get available():Boolean {
      try
      {
  			if (NetUtils.runsLocal) return false;
  			if (!ExternalInterface.available) return false;
  			if (String(ExternalInterface.call("window.location.href.toString")) == "null") return false;
      } catch(e:Error)
      {
        return false;
      }
      
      return true;
		}
		
    
    public static function alert(value:String):void {
      if(available) ExternalInterface.call("alert", value);
      else          trace(value);
    }
    
    public static function log(value:String):void {
      if(available) ExternalInterface.call("console.log", value);
      else          trace(value);
    }
		
		public static function debug(value:String):void {
			if(available) ExternalInterface.call("debug", value);
			else          trace(value);
		}
		
		
    
		// DEFINE A URL KEY / VALUE PAIR
		public function define(index:*, key:*, defaultValue:* = ''):void {
			_keys[int(index)]    = String(key);
			_default[int(index)] = String(defaultValue);
			_url[int(index)]     = String(defaultValue);
			
			var dispatchedLocation:Array = location.replace("#" + BEGINNING, "").replace("#","").split(DELIMETER);
			
			if(dispatchedLocation[int(index)] != "") _url[int(index)] = dispatchedLocation[int(index)];
      //_query.data = _query.dispatch(queryString);
		}
		
		
		// GET DEFAULT VALUE DEFINED ABOVE
		public function getDefault(key:* = ""):String {
      key = String(key);
			if(key == "") return join(_default);
			return String(_default[getIndex(String(key))]);
		}
		
		
		// SET COMPLETE URL (e.g: de/area)
		public function set url(area:String):void {
			area = area.replace("#" + BEGINNING, "").replace("#", "");
			_url = area.split(DELIMETER);
			
			if(available) hash = join(_url);
		}
		
    
    // GET COMPLETE URL
		public function get url():String {
			return join(_url);
		}
		
    
		
    // GET HASH LOCATION VALUE
		public function get(key:* = ""):String {
			if(String(key) == "") return join(_url);
			return String(_url[getIndex(String(key))]);
		}
		
    
    // UPDATE SET OF LOCATIONS
		public function update(location:Object):String {
      for (var key:String in location)
      {
        _url[getIndex(key)]= String(location[key]);
      }
      
      _query.data = {};
      
      if (available) hash = join(_url);
      return join(_url);
    }
    
    
    // SET VALUE BY KEY
		public function set(key:*, val:*):String {
			_url[getIndex(String(key))]= String(val);
      _query.data = {};
			
			if(available) hash = join(_url);
			return join(_url);
		}
		
    
    // SET VALUE / RESET RIGHT ONES
		public function to(key:* = "", val:* = ""):String {
      key = String(key);
			if(key == "") return join(_url);
			
			var index:int = getIndex(String(key));
			
			for (var i:int = index; i < _url.length; i++) _url[i] = "";
			
			_url[index] = String(val);
      _query.data = {};
			
			if(available) hash = join(_url);
			return join(_url);
		}
		
		
    
    
    private function updateQuery(event:LocationEvent):void 
    {
      if(available) hash = location + _query.patch();
      log(location);
      dispatchEvent(event);
    }
    
    
    
		
		private function join(array:Array):String {
      var hashLocation:String = array.join(DELIMETER);
			while(hashLocation.indexOf(DELIMETER + DELIMETER) >= 0) hashLocation = hashLocation.replace(DELIMETER + DELIMETER, DELIMETER);
			return hashLocation;
		}
		
		private function set hash(hashLocation:String):void {
			while(hashLocation.indexOf(DELIMETER + DELIMETER) >= 0) hashLocation = hashLocation.replace(DELIMETER + DELIMETER, DELIMETER);
			if(hashLocation.substr(hashLocation.length - 1, 1) != DELIMETER) hashLocation += DELIMETER;
			navigateToURL(new URLRequest("#" + BEGINNING + hashLocation), "_self");
		}
		
    
		private function get location():String {
			if(available)
			{
				var windowLocation:String = String(ExternalInterface.call("window.location.href.toString"));
        if(windowLocation.indexOf('?') >= 0) windowLocation = windowLocation.substring(0, windowLocation.indexOf('?'));
				if(windowLocation.indexOf("#" + BEGINNING) < 0) return "";
				return windowLocation.substring(windowLocation.indexOf("#" + BEGINNING) + 1 + BEGINNING.length);
			}
			else return join(_url);
		}
    
    private function get queryString():String {
      if(available)
      {
        var windowLocation:String = String(ExternalInterface.call("window.location.href.toString"));
        if(windowLocation.indexOf('?') >= 0) return windowLocation.substring(windowLocation.indexOf('?'));
      }
      else return _queryString;
			return _queryString;
    }
		
		
		private function getIndex(area:String):int {
			for (var i:int = 0; i < _keys.length; i++)
			{
				if (_keys[i] == area) return i;
			}
			
			return -1;
		}
		
		private function restartInterval():void {
			
			function startInterval():void
			{
				_recheckInterval = setInterval(checkLocation, _recheckTime);
			}
			
			if (_recheckInterval) clearInterval(_recheckInterval);
			setTimeout(startInterval, _recheckWait);
		}
		
		
		
		// CHECK HASH-LOCATION / DISPATCH ON NEW LOCATION
		
		private function checkLocation():void {
			if(_location != location)
			{
				_location = location;
				_url = _location.split(DELIMETER);
        //if(available) hash = join(_url) + _query.patch();
        
				restartInterval();
				
				if (Config.instance.debug) core.actions.log(_location, this);
				
				dispatchEvent(new LocationEvent(LocationEvent.LOCATION_CHANGE, _location));
			}
      
      /*
      if(_queryString != queryString)
      {
        _queryString = queryString;
        _query.dispatch(_queryString);
        dispatchEvent(new LocationEvent(LocationEvent.QUERY_CHANGE, _queryString));
      }
      */
		}
		
    
    
		
	}
	
}
