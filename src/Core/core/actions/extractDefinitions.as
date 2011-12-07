package core.actions
{
	import core.api.ObjectDescription;
	
	import flash.utils.describeType;
	
	public function extractDefinitions(object:*):ObjectDescription
	{
		if (String(object).indexOf('[class') == -1) object = Object(object).constructor;
		
		var desc             : XML   = describeType(object);
		var staticMethods    : Array = [];
		var staticProperties : Array = [];
		var memberMethods    : Array = [];
		var memberProperties : Array = [];
		var key:String;
		
		for (key in desc.method)            staticMethods.push(desc.method.@name[key]);
		for (key in desc.variable)          staticProperties.push(desc.variable.@name[key]);
		for (key in desc.factory.method)    memberMethods.push(desc.factory.method.@name[key]);
		for (key in desc.factory.variable)  memberProperties.push(desc.factory.variable.@name[key]);
		for (key in desc.factory.accessor)  memberProperties.push(desc.factory.accessor.@name[key]);
		
		return new ObjectDescription(staticMethods, staticProperties, memberMethods, memberProperties);
	}
}