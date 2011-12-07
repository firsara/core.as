package core.media
{
	import core.api.Config;
	import core.events.VideoEvent;
	import core.actions.log;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class Video extends Sprite
  {
		
		private const BASE_WIDTH:Number = 320;
		private const BASE_HEIGHT:Number = 240;
		
		// PARAMETERS
		private var _url:String;
		private var _auto:Boolean;
		private var _loading:Boolean;
		private var _volume:Number;
		private var _storeVol:Number;
		
		// VIDEO OBJECTS
		private var _clip:flash.media.Video;
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _client:Object;
		private var _meta:Object;
		private var _playing:Boolean;
		
		private var _fitWidth:Number;
		private var _fitHeight:Number;
		
		public function get isPlaying():Boolean       { return (_playing == true); }
		public function get duration()  :Number       { return (ready ? (_meta.duration || 1) : 1) }
		public function get stream()    :NetStream    { return _stream; }
		public function get ready()     :Boolean      { return (_meta != null); }
		public function get meta()      :Object       { return _meta }
		public function get volume()    :Number       { return _volume; }
		public function set volume(value:Number):void
		{
			_volume = value;
			if (ready) _stream.soundTransform = new SoundTransform(value);
		}
		
		
		
		public function Video(width:Number = 320, height:Number = 240)
		{
			_clip = new flash.media.Video(BASE_WIDTH, BASE_HEIGHT);
			_clip.smoothing = true;
			
			addChild(_clip);
			
			this.width = width;
			this.height = height;
			
			_volume = 1;
		}
		
		
		public function load(url:String):void
		{
			_url = url;
			_auto = false;
			startStream();
		}
		
		public function play(url:String = ""):void
		{
			_auto = true;
			
			if (url == "" && ready) resume();
			else
			{
				if (url != "") _url = url;
				if (_url == "") return;
				if (_url == url && !_loading) startStream();
			}
		}
		
		public function resume():void
		{
			volume = _volume;
			_stream.resume();
			_playing = true;
		}
		
		public function pause():void
		{
			_storeVol = volume;
			volume = 0;
			
			_stream.pause();
			
			volume = _storeVol;
			_playing = false;
		}
		
		public function stop():void
		{
			pause();
			_stream.seek(0);
			_playing = false;
		}
		
		
		public function fit(widthArea:Number, heightArea:Number):void
		{
			if (!ready)
			{
				_fitWidth = widthArea;
				_fitHeight = heightArea;
				return;
			}
			
			if (this.height / heightArea > this.width / widthArea)
				   this.height = heightArea;
			else this.width = widthArea;
		}
		
    
    public override function get width():Number { return _clip.width; }
    public override function get height():Number { return _clip.height; }
		
		public override function set width(value:Number):void
		{
			_clip.width = value;
			rescaleY();
		}
		public override function set height(value:Number):void
		{
			_clip.height = value;
			rescaleX();
		}
		
    public override function get x():Number { return _clip.x; }
    public override function get y():Number { return _clip.y; }
		public override function set x(value:Number):void { _clip.x = value; }
		public override function set y(value:Number):void { _clip.y = value; }
    
    
		
		
		private function rescaleX():void { if(ready) _clip.scaleX = (_clip.scaleY * _meta.ratio); }
		private function rescaleY():void { if(ready) _clip.scaleY = (_clip.scaleX / _meta.ratio); }
		
		
		private function startStream():void
		{
			dispose();
			_loading = true;
			
			_client = new Object();
			_client.onMetaData = getMetaData;
			
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			_connection.connect(null);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		
		private function getMetaData(metaData:Object):void
		{
			_meta = metaData;
			_meta.ratio = ((_meta.width / _meta.height) / (BASE_WIDTH / BASE_HEIGHT));
			_loading = false;
			
			if (Config.instance.debug) core.actions.log("Video -> width: " + String(_meta.width) + " | height: " + String(_meta.height), this);
			
			if (width > height)
					 rescaleX();
			else rescaleY();
			
			if (_fitWidth) fit(_fitWidth, _fitHeight)
			
			if (!_auto) _stream.pause();
			volume = _storeVol;
			_clip.visible = true;
			
			dispatchEvent(new VideoEvent(VideoEvent.READY));
		}
		
		
		private function connect(connection:NetConnection):void
		{  
			_stream = new NetStream(_connection);
			_clip.attachNetStream(_stream);
			
			_stream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncError);
			_stream.client = _client;
			_stream.play(_url);
			_clip.visible = false;
			
			volume = 0;
		}
		
		
		// EVENTS
		private function securityError(event:SecurityErrorEvent):void { if (Config.instance.debug) core.actions.log("securityError: " + event, this); }
		private function asyncError   (event:AsyncErrorEvent)   :void { if (Config.instance.debug) core.actions.log("asyncErrorHandler: " + event.text, this); }
		private function videoStatus  (event:NetStatusEvent)    :void
		{
			if (Config.instance.debug) core.actions.log("target = " + event.target + " currentTarget = " + event.currentTarget + "  info-code: " + event.info.code, this);
			switch (event.info.code) 
			{
				case "NetConnection.Connect.Success": connect(_connection); break;
				case "NetStream.Play.Start": _playing = true; break;
				case "NetStream.Play.Stop": _playing = false; dispatchEvent(new VideoEvent(VideoEvent.COMPLETE)); break;
				case "NetStream.Pause.Notify": _playing = false; break;
			}
		}
		
		
		
		
		private function dispose(event:Event = null):void
		{
			_loading = false;
			_storeVol = volume;
			volume = 0;
			_clip.clear();
			
			if (_stream)
			{
				_stream.pause();
				_stream.close();
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncError);
			}
			
			if (_connection)
			{
				_connection.close();
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			}
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
					
					
	}
}
