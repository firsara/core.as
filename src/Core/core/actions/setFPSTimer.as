package core.actions
{
	import core.api.def.stage;
	import flash.utils.setInterval;
	
	public function setFPSTimer(closure:Function, frames:Number, ...parameters):uint
	{
		var timeout:int = (1000 / core.api.def.stage.frameRate * Math.max(1, frames));
		
		if (parameters.length > 0)
			   return setInterval(closure, timeout, parameters);
		else return setInterval(closure, timeout);
	}
}
