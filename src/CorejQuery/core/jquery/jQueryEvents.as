package core.jquery
{
	import core.actions.dynamicFunctionCall;
	import core.actions.monitorClip;
	import core.actions.unmonitorClip;
	
	import flash.events.Event;

	public class jQueryEvents
	{
		public static function die(self:jQuery, target:*):void
		{
			unbind(self);
			target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			core.actions.unmonitorClip(target);
		}
		
		
		
		public static function addedToStage(self:jQuery, callback:Function):void
		{
			self.addedToStageCallback = callback;
			if (self.target.stage) callback();
			else self.target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public static function removedFromStage(self:jQuery, callback:Function):void
		{
			self.removedFromStageCallback = callback;
			self.target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public static function resize(self:jQuery, callback:Function):void
		{
			core.actions.monitorClip(self.target, callback, callback);
		}
		
		public static function bind(self:jQuery, event:String, callback:Function):void
		{
			if (!self.store) self.store = {};
			if (!self.store.jQueryEvents) self.store.jQueryEvents = {};
			self.store.jQueryEvents['event' + event.toUpperCase()] = { event: event, callback: callback };
			self.target.addEventListener(event, callback);
		}
		
		public static function unbind(self:jQuery, event:String = ''):void
		{
			var key:String;
			var bindSubject:Object;
			
			if (event == '')
			{
				if (self.store && self.store.jQueryEvents)
				{
					for each (bindSubject in self.store.jQueryEvents) self.target.removeEventListener(bindSubject.event, bindSubject.callback);
				}
			}
			else
			{
				self.target.removeEventListener(event, self.store.jQueryEvents['event' + event.toUpperCase()].callback);
			}
		}
		
		
		
		
		
		
		private static function onAddedToStage(e:Event):void
		{
			var self:jQuery = jQuery.getInstance(e.currentTarget);
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var callback:Function = (self.addedToStageCallback as Function);
			self.addedToStageCallback = null;
			
			core.actions.dynamicFunctionCall(callback, e);
		}
		
		
		private static function onRemovedFromStage(e:Event):void
		{
			var self:jQuery = jQuery.getInstance(e.currentTarget);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			var callback:Function = (self.removedFromStageCallback as Function);
			self.removedFromStageCallback = null;
			
			core.actions.dynamicFunctionCall(callback, e);
		}
		
	}
}