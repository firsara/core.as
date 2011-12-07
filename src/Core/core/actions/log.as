package core.actions
{
	import core.utils.Time;
	import flash.utils.getQualifiedClassName;
	
	public function log(value:String, caller:* = null):void
	{
		//if(!Console) return;
		
		var debugText:String;
		debugText = "[" + Time.formatTime(Time.now) + "]   ";
		debugText += (caller != null ? getQualifiedClassName(caller) + " -> " : "");
		debugText += value;
		
		//if (Config.instance.console) Console.log(debugText);
		trace(debugText);
	}
}