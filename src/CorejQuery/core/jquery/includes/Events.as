import core.jquery.jQuery;
import core.jquery.jQueryEvents;


/*   jQuery EVENTS functions          */
/*   CLASS: core.jquery.jQueryEvents  */
/*------------------------------------*/

public function addedToStage     (callback:Function)               :jQuery   { jQueryEvents.addedToStage(this, callback); return this; }
public function removedFromStage (callback:Function)               :jQuery   { jQueryEvents.removedFromStage(this, callback); return this; }


public function resize           (callback:Function)               :jQuery   { jQueryEvents.resize(this, callback); return this; }
public function bind             (event:String, callback:Function) :jQuery   { jQueryEvents.bind(this, event, callback); return this; }
public function unbind           (event:String = '')               :jQuery   { jQueryEvents.unbind(this, event); return this; }

public function click            (callback:Function)               :jQuery   { jQueryEvents.bind(this, 'click', callback); return this; }
