package core.actions
{
	import flash.net.LocalConnection;
	import flash.system.System;

	public function gc():void
	{
		trace("System Total Memory BEFORE Garbage Collection: " + System.totalMemory );
		
		try
		{
			new LocalConnection().connect('_foo');
			new LocalConnection().connect('_foo');
		}
		catch(e:Error)
		{
			trace('garbage collected');
			trace("System Total Memory BEFORE Garbage Collection: " + System.totalMemory );
		}
	}
}