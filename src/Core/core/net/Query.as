// QUERY DISPATCHER

package core.net
{
  import core.events.LocationEvent;
  import core.net.Location;
  
  import flash.events.EventDispatcher;
  
  public class Query extends EventDispatcher
  {
    private var _data:Object;
    private var _query:String;
    private var _callback:Function;
    
    public function set data(value:Object):void
    {
      _data = value;
      this.dispatchEvent(new LocationEvent(LocationEvent.QUERY_CHANGE));
    }
    
    
    public function clear():void
    {
      data = {};
    }
    
    
    
    public function get(key:* = ""):String
    {
      if (_data[String(key)]) return String(_data[String(key)]);
      return '';
    }
    
    
    public function set(key:*, value:*):String
    {
      _data[String(key)] = String(value);
      this.dispatchEvent(new LocationEvent(LocationEvent.QUERY_CHANGE));
			return value;
    }
    
    
    
    public function patch():String
    {
      var query:String = '';
      var key:String, value:String;
      for (key in _data) query += ('&' + key + '=' + _data[key]);
      
      _query = query;
      
      if (query == '') return '';
      
      return('?' + query.substring(1));
    }
    
    public function dispatch(query:String):Object
    {
      query = (query == null ? '' : String(query));
      if (query == '') return {};
      if (query.substring(0, 1) == '?') query = query.substring(1);
      
      var temp:Object = {};
      var pairs:Array = query.split('&');
      var pair:Array, key:String, value:String;
      
      for each (var element:String in pairs)
      {
        pair = element.split('=');
        key = String(pair[0]);
        value = String(pair[1]);
        temp[key] = value;
      }
      
      return temp;
    }
    
    
    
    
    
    public function Query():void
    {
      super();
      _data = {};
      _query = "";
    }
  }
  
}