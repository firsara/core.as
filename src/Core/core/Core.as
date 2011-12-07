package core
{
	import core.actions.log;
	import core.api.Classes;
	import core.api.Config;
	import core.api.def.main;
	import core.api.def.stage;
	import core.events.CoreEvent;
	import core.settings.StageSetup;
	import core.utils.NetUtils;
	import core.utils.Time;
	
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	
	final public class Core
	{
		include 'VERSION.as';
		include '_inc_/StaticEventHandler.as';
		
		public function Core()
		{
			throw new Error('Core can only be initialized via  >  Core.init  <');
		}
		
		
		// Core util functions
		
		public static function require(extension:Class):void           { _.require(extension); }
		public static function log(value:String, caller:* = null):void { core.actions.log(value, caller); }
		public static function unload(asset:Loader):void               { NetUtils.unload(asset); }
		public static function get now():Number                        { return Time.now; }
		public static function get runsLocal():Boolean                 { return NetUtils.runsLocal; }
		
		
		
		// Core Classes
		
		private static var _readyEvent        :CoreEvent;
		private static var _input             :String;
		private static var _initCallback      :Function;
		
		
		public static function get ready()    :Boolean      { return (_readyEvent != null); }
		
		public static function get root()     :Object       { return core.api.def.main; }
		public static function get stage()    :Stage        { return core.api.def.stage; }
		
		public static function get config()   :Config       { return Config.instance; }
		public static function get classes()  :Classes      { return Classes.instance; }
		
		//public static function get input()    :String       { return _input; }
		//public static function set input(value:String):void
		//{
			//InputHandler.dispose();
			//_input = value;
			//InputHandler.init();
		//}
		
		
		
		// MAIN CORE CONSTRUCTION
		
		public static function init(mainReference:Object, callback:Function = null):void
		{
			if (ready) throw new Error('Core already initialized');
			
			_initCallback = callback;
			core.api.def.main = mainReference;
			
			if (core.api.def.main.stage) construct();
			else core.api.def.main.addEventListener(Event.ADDED_TO_STAGE, construct);
		}
		
		
		private static function construct(event:Event = null):void
		{
			if (event) core.api.def.main.removeEventListener(Event.ADDED_TO_STAGE, construct);
			
			
			// STAGE SETUP
			core.api.def.stage = Stage(core.api.def.main.stage);
			core.api.def.stage.scaleMode              = StageSetup.stageScaleMode;
			core.api.def.stage.align                  = StageSetup.stageAlign;
			core.api.def.stage.stageFocusRect         = StageSetup.stageFocusRect;
			core.api.def.stage.showDefaultContextMenu = StageSetup.showDefaultContextMenu;
			
			// INPUT MODE SETUP
			//_input = InputSetup.inputMode;
			//InputHandler.init();
			
			Config.instance.setup();
			
			_readyEvent = new CoreEvent(CoreEvent.CORE_READY);
			dispatchEvent(_readyEvent);
			
			core.actions.dynamicFunctionCall(_initCallback, _readyEvent);
		}
		
		
		
		// STATIC
		{
			(function():void
			{
				trace('-------------');
				trace('starting core');
				trace('-------------');
			}
				()
			);
		}
		
	}
}