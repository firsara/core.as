﻿package core.media{	import core.vars.SoundTrackVars;		import flash.events.Event;	import flash.system.ApplicationDomain;	import flash.utils.Dictionary;	import flash.utils.getDefinitionByName;		public class SoundHandler  {		include '../_inc_/StaticRequire.as';		private static var         _instance :SoundHandler;		public static function get instance():SoundHandler { return _instance; }				public static var fadeSpeed:Number = 0.85;				private var _sounds:Dictionary;						public function SoundHandler()		{			include '../_inc_/StaticRequireValidation.as';						_instance = this;			_sounds = new Dictionary();		}				public function play(path:String, id:String = "", parameters:SoundTrackVars = null):void    {			if (path == "") return;			if (id == "") id = uniqueID;			if (_sounds[id]) SoundTrack(_sounds[id]).stop();						var sound:SoundTrack = new SoundTrack();			sound.addEventListener(Event.SOUND_COMPLETE, function():void{ endSound(id); } );			sound.parameters = parameters;			sound.play(path);						_sounds[id] = sound;		}				public function playAsset(name:String, id:String = "", parameters:SoundTrackVars = null):void    {			if (!ApplicationDomain.currentDomain.hasDefinition(name)) return;			if (id == "") id = uniqueID;			if (_sounds[id]) _sounds[id].Stop();						var TrackReference:Class = getDefinitionByName(name) as Class;						var sound:SoundTrack = new SoundTrack();			sound.addEventListener(Event.SOUND_COMPLETE, function():void{ endSound(id); } );			sound.track = new TrackReference();			sound.parameters = parameters;			sound.play();						_sounds[id] = sound;		}		    public function stop(id:String):void    {      SoundTrack(_sounds[id]).stop();    }    		public function stopAll():void    {			for each (var sound:SoundTrack in _sounds) sound.stop();		}				private function endSound(id:String):void    {			if (!_sounds[id]) return;			if (!SoundTrack(_sounds[id]).alive) delete _sounds[id];		}				private function get uniqueID():String    {			var valid:Boolean = false;			var id:String;						while(!valid)      {				id = String(Math.random() * int.MAX_VALUE);				if (_sounds[id]) valid = false;				else valid = true;			}						return id;		}				public function get    (id:String):SoundTrack { return SoundTrack(_sounds[id]); }		public function fadeIn (id:String):void       { SoundTrack(_sounds[id]).fadeIn(); }		public function fadeOut(id:String):void       { SoundTrack(_sounds[id]).fadeOut(); }	}	}