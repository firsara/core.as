package core.utils
{
  public final class Convert
  {
		
    public static function objectToXML(object:Object):XML
    {
      function appendData(object:Object):void
      {
        for (var key:String in object)
        {
          data += '<property key="'+key+'" value="'+object[key]+'">' + "\n";
          appendData(object[key]);
          data += '</property>';
        }
      }
      
      var data:String = '';
      appendData(object);
      data = '<data>' + data + '</data>';
      
      return new XML(data);      
    }
    
		
    public static function xmlToObject(data:XML, targetObject:Object = null):Object
    {
			if (targetObject == null) targetObject = new Object();
      assignXMLValues(data, targetObject);
      return targetObject;
    }
		
		private static function assignXMLValues(data:XML, targetObject:Object = null):Object
		{
			if (targetObject == null) targetObject = new Object();
			
			var key:String;
			var value:String;
			
			for each (var node:XML in data.property)
			{
				key = String(node.attribute('key'));
				value = String(node.attribute('value'));
				if (node.property.length() > 0)
				{
					targetObject[key] = new Object();
					assignXMLValues(node, targetObject[key]);
				}
				else
				{
					targetObject[key] = value;
				}
			}
			
			return targetObject;
		}
		
		
		
		
		public static function xmlListToArray(source:XMLList):Array
		{
			var dataArray:Array = new Array();
			for each (var child:XML in source) dataArray.push(child);
			
			return dataArray;
		}
		
  }
}