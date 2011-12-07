package core.media
{
	import core.animation.Tween;
	import core.api.Classes;
	import core.api.def.stage;
	import core.events.VideoEvent;
	import core.actions.clearFPSTimer;
	import core.actions.setFPSTimer;
	import core.text.Text;
	import core.utils.NetUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class VideoPlayer extends Video
  {
		// PROPERTIES
		private const HIDE_TIMEOUT:Number = 2000;
		private const BUFFER_PADDING:Number = 300;
		private const TIME_PADDING:Number = 30;
		private const SCRUB_FPS:int = 10;
		private const BUFFER_FPS:int = 5;
		
		private var _backgroundColor:uint;
		
		private var _skin:Loader;
		private var _skinURL:String;
		private var _scaleMode:String;
    private var _align:String;
		
		
		// OBJECTS
		private var _trigger:Sprite;
		private var _mask:Sprite;
		private var _background:Sprite;
		private var _controls:Sprite;
		private var _timeline:Sprite;
		private var _controlBar:Sprite;
		
		// TIMELINE
		private var _timelineBG:Sprite;
		private var _bufferEmpty:Sprite;
		private var _bufferFill:Sprite;
		private var _bufferMask:Sprite;
		private var _scrubber:Sprite;
		private var _timePlayed:Text;
		private var _timeLeft:Text;
		
		// CONTROLS
		private var _skipLeft:Sprite;
		private var _skipRight:Sprite;
		private var _play:Sprite;
		private var _pause:Sprite;
		
		// HELPER
		private var _bufferTimer:uint;
		private var _scrubTimer:uint;
		private var _hideTimeout:uint;
		private var _storePosition:Number;
		private var _scrubbing:Boolean;
		private var _wasPlaying:Boolean;
		private var _showTimeTotal:Boolean;
		private var _bufferWidth:Number;
		
		
		private var _selfWidth:Number;
		private var _selfHeight:Number;
		
		
    public function get align():String { return _align; }
    public function set align(value:String):void
    {
      _align = value;
      resize();
    }
    
		public function get scaleMode():String { return _scaleMode; }
		public function set scaleMode(value:String):void
		{
			_scaleMode = value;
			resize();
		}
		
		
		public function get skin():String { return _skinURL; }
		public function set skin(url:String):void
		{
			_skinURL = url;
			if (super.ready) loadSkin();
		}
		
		
		public function get background():uint { return _backgroundColor; }
		public function set background(value:uint):void
		{
			_backgroundColor = value;
			redraw();
		}
		
		
		public function VideoPlayer(width:Number = 320, height:Number = 240)
		{
			_showTimeTotal = true;
			
			_selfWidth = width;
			_selfHeight = height;
			
			_background = new Sprite();
			_backgroundColor = 0x000000;
      
			_trigger = new Sprite();
			//_mask = new Sprite();
			
			super(width, height);
			super.addChild(_background);
			super.setChildIndex(_background, 0);
			redraw();
			
			_trigger.doubleClickEnabled = true;
			_trigger.graphics.beginFill(0xFF0000, 0);
			_trigger.graphics.drawRect(0, 0, width, height);
			_trigger.graphics.endFill();
			this.addChild(_trigger);
			
			//_mask.graphics.beginFill(0xFF0000, 1);
			//_mask.graphics.drawRect(0, 0, width, height);
			//_mask.graphics.endFill();
			//this.addChild(_mask);
			//super.mask = _mask;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			this.addEventListener(VideoEvent.READY, construct);
			_trigger.addEventListener(MouseEvent.DOUBLE_CLICK, toggleFullscreen);
			core.api.def.stage.addEventListener(Event.RESIZE, resize);
		}
		
		public function toggleFullscreen(event:MouseEvent = null):void
		{
			if (core.api.def.stage.displayState == StageDisplayState.FULL_SCREEN)
				   core.api.def.stage.displayState = StageDisplayState.NORMAL;
			else core.api.def.stage.displayState = StageDisplayState.FULL_SCREEN;
			
			core.api.def.stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		
		public override function fit(widthArea:Number, heightArea:Number):void
		{
			super.fit(widthArea, heightArea);
			_selfWidth = widthArea;
			_selfHeight = heightArea;
			
			redraw();
			resize();
			resizeSkin();
		}
		
		//public override function get width():Number { return _background.width; }
		//public override function get height():Number { return _background.height; }
		
		public override function set width(value:Number):void
		{
			super.width = value;
			_selfWidth = value;
			//_selfHeight = super.height;
			redraw();
			resize();
			resizeSkin();
		}
		public override function set height(value:Number):void
		{
			super.height = value;
			_selfHeight = value;
			//_selfWidth = super.width;
			redraw();
			resize();
			resizeSkin();
		}
		
		private function redraw():void
		{
			_background.graphics.clear();
			_background.graphics.beginFill(_backgroundColor, 1);
			_background.graphics.drawRect(0, 0, _selfWidth, _selfHeight);
			_background.graphics.endFill();
			
			_trigger.width = _selfWidth;
			_trigger.height = _selfHeight;
			//_mask.width = _selfWidth;
			//_mask.height = _selfHeight;
		}
		
		
		
		
		private function construct(event:VideoEvent):void
		{
			this.removeEventListener(VideoEvent.READY, construct);
			
			_trigger.width = super.width;
			_trigger.height = super.height;
			_selfWidth = super.width;
			_selfHeight = super.height;
			
			if (_skinURL && !_skin) loadSkin();
			
			resize();
		}
		
		
		
		private function loadSkin():void
		{
			disposeSkin();
			
			_skin = new Loader();
			_skin.contentLoaderInfo.addEventListener(Event.COMPLETE, renderSkin);
			_skin.load(new URLRequest(_skinURL), new LoaderContext());
		}
		
		
		
		
		
		// SCRUBBING AND BUFFERING
		// -----------------------
		
		private function convertTime(time:Number):String
		{
			time = Math.round(time);
			var minutes:Number = Math.floor(time / 60);
			var seconds:Number = Math.round(time - minutes * 60);
			
			return (minutes + ':' + seconds);
		}
		
		private function buffer():void
		{
			var loaded:Number = super.stream.bytesLoaded / super.stream.bytesTotal;
			
			if (_scrubbing != true)
			_scrubber.x = _bufferEmpty.x + (super.stream.time / super.duration) * _bufferEmpty.width;
			_bufferMask.width = loaded * _bufferEmpty.width;
			
			_timePlayed.value = convertTime(super.stream.time);
			
			if (_showTimeTotal == true)
				   _timeLeft.value = convertTime(super.duration);
			else _timeLeft.value = "-" + convertTime(super.duration - super.stream.time);
			
			if (super.isPlaying)
			{
				_pause.visible = true;
				_play.visible = false;
			}
			else
			{
				_pause.visible = false;
				_play.visible = true;
			}
			
			
			resizeLabels();
			resize();
		}
		
		
		private function startScrub(event:MouseEvent):void
		{
			_wasPlaying = super.isPlaying;
			
			super.pause();
			_scrubbing = true;
			_storePosition = core.api.def.stage.mouseX;
			_scrubber.removeEventListener(MouseEvent.MOUSE_DOWN, startScrub);
			core.api.def.stage.addEventListener(MouseEvent.MOUSE_UP, stopScrub);
			_scrubTimer = setFPSTimer(scrub, SCRUB_FPS);
		}
		
		private function stopScrub(event:MouseEvent):void
		{
			if (_wasPlaying) super.resume();
			
			_scrubbing = false;
			_scrubber.addEventListener(MouseEvent.MOUSE_DOWN, startScrub);
			_scrubber.removeEventListener(Event.ENTER_FRAME, scrub);
			core.api.def.stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrub);
			clearFPSTimer(_scrubTimer);
		}
		
		private function scrub(event:Event = null):void
		{
			scrubTo(_scrubber.x + (core.api.def.stage.mouseX - _storePosition));
			_storePosition = core.api.def.stage.mouseX;
		}
		
		private function scrubTo(position:Number):void
		{
			_scrubber.x = position;
			
			if (_scrubber.x < _bufferEmpty.x) _scrubber.x = _bufferEmpty.x;
			else if (_scrubber.x > _bufferMask.x + _bufferMask.width) _scrubber.x = _bufferMask.x + _bufferMask.width;
			
			super.stream.seek((_scrubber.x - _bufferEmpty.x) / _bufferEmpty.width * super.duration);
		}
		
		private function envokeSeek(event:MouseEvent):void
		{
			scrubTo(_timeline.mouseX);
		}
		
		// -----------------------
		
		
		
		
		
		
		// USER IDLE EVENTS
		// ----------------
		
		private function hideControls():void { fadeControls(0); }
		private function showControls():void { fadeControls(1); }
		
		private function fadeControls(a:Number):void
		{
			Tween.stop(_controls);
			Tween.to(_controls, Tween.SLOW, {autoAlpha: a});
		}
		
		private function mouseMoved(event:MouseEvent):void
		{
			if (_controls.alpha != 1) showControls();
			if (_hideTimeout) clearTimeout(_hideTimeout);
			_hideTimeout = setTimeout(mouseNotMoved, HIDE_TIMEOUT);
		}
		private function mouseNotMoved():void
		{
			hideControls();
		}
		
		// ----------------
		
		
		
		
		// CONTROL EVENTS
		//--------------
		
		private function toggleShowTimeState(event:MouseEvent):void
		{
			if (_showTimeTotal == true) _showTimeTotal = false;
			else _showTimeTotal = true;
		}
		
		private function playVideo(event:MouseEvent):void
		{
			if (super.stream.time >= super.duration * .98) super.stream.seek(0);
			super.resume(); 
		}
		private function pauseVideo(event:MouseEvent):void
		{
			super.pause();
		}
		private function skipLeft(event:MouseEvent):void {
			super.stop();
		}
		private function skipRight(event:MouseEvent):void
		{
			super.stream.seek(super.duration);
			super.pause();
		}
		
		//--------------
		
		
		
		
		
		// RESIZING SKIN AND BUTTONS
		// -------------------------
		
		private function renderSkin(event:Event):void
		{
			event.currentTarget.addEventListener(Event.COMPLETE, renderSkin);
			
			var domain:ApplicationDomain = _skin.contentLoaderInfo.applicationDomain;
			
			// TIMELINE
			
			_timelineBG = new Sprite();
			_bufferEmpty = new Sprite();
			_bufferFill = new Sprite();
			_bufferMask = new Sprite();
			_scrubber = new Sprite();
			
			_timePlayed = new Text('00:00', 'VideoPlayer');
			_timeLeft = new Text('00:00', 'VideoPlayer');
			_timeLeft.addEventListener(MouseEvent.CLICK, toggleShowTimeState);
			
			// BACKGROUND
			_timelineBG.addChild(Classes.instance.getDisplayObject('player.bar.background', domain));
			
			// BUFFER EMPTY
			_bufferEmpty.addChild(Classes.instance.getDisplayObject('player.buffer.empty', domain, 'bar'));
			_bufferEmpty.addChild(Classes.instance.getDisplayObject('player.buffer.empty.left', domain, 'left'));
			_bufferEmpty.addChild(Classes.instance.getDisplayObject('player.buffer.empty.right', domain, 'right'));
			
			// BUFFER FILL
			_bufferFill.addChild(Classes.instance.getDisplayObject('player.buffer.fill', domain, 'bar'));
			_bufferFill.addChild(Classes.instance.getDisplayObject('player.buffer.fill.left', domain, 'left'));
			_bufferFill.addChild(Classes.instance.getDisplayObject('player.buffer.fill.right', domain, 'right'));
			_bufferFill.addEventListener(MouseEvent.CLICK, envokeSeek);
			
			// BUFFER MASK
			_bufferMask.graphics.beginFill(0xFF0000, 1);
			_bufferMask.graphics.drawRect(0, 0, 100, _bufferFill.height + 4);
			_bufferMask.graphics.endFill();
			
			// SCRUBBER
			var _scrubberHandle:DisplayObject = Classes.instance.getDisplayObject('player.scrubber.handle', domain);
			_scrubberHandle.x = 0 - _scrubberHandle.width / 2;
			_scrubberHandle.y = 0 - _scrubberHandle.height / 2;
			_scrubber.addChild(_scrubberHandle);
			
			_scrubber.buttonMode = true;
			_scrubber.addEventListener(MouseEvent.MOUSE_DOWN, startScrub);
			_scrubber.addChild(_scrubberHandle);
			
			_timeline = new Sprite();
			_timeline.addChild(_timelineBG);
			_timeline.addChild(_bufferEmpty);
			_timeline.addChild(_bufferFill);
			_timeline.addChild(_bufferMask);
			_timeline.addChild(_scrubber);
			_timeline.addChild(_timePlayed);
			_timeline.addChild(_timeLeft);
			
			
			
			// CONTROL BAR
			
			_skipLeft = new Sprite();
			_skipRight = new Sprite();
			_play = new Sprite();
			_pause = new Sprite();
			_skipLeft.buttonMode = _skipRight.buttonMode = _play.buttonMode = _pause.buttonMode = true;
			
			var tempSkipLeft:DisplayObject = Classes.instance.getDisplayObject('player.control.skip', domain);
			tempSkipLeft.x = tempSkipLeft.width;
			tempSkipLeft.scaleX = -1;
			
			_skipLeft.addChild(tempSkipLeft);
			_skipRight.addChild(Classes.instance.getDisplayObject('player.control.skip', domain));
			_play.addChild(Classes.instance.getDisplayObject('player.control.play', domain));
			_pause.addChild(Classes.instance.getDisplayObject('player.control.pause', domain));
			
			_skipLeft.addEventListener(MouseEvent.CLICK, skipLeft);
			_skipRight.addEventListener(MouseEvent.CLICK, skipRight);
			_play.addEventListener(MouseEvent.CLICK, playVideo);
			_pause.addEventListener(MouseEvent.CLICK, pauseVideo);
			
			
			_controlBar = new Sprite();
			_controlBar.addChild(Classes.instance.getDisplayObject('player.control.bar', domain));
			_controlBar.addChild(_skipLeft);
			_controlBar.addChild(_skipRight);
			_controlBar.addChild(_play);
			_controlBar.addChild(_pause);
			
			
			
			_controls = new Sprite();
			_controls.addChild(_timeline);
			_controls.addChild(_controlBar);
			this.addChild(_controls);
			
			_controls.alpha = 0;
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			
			_bufferFill.mask = _bufferMask;
			_bufferMask.width = 0;
			
			resizeSkin();
			_bufferTimer = setFPSTimer(buffer, BUFFER_FPS);
		}
		
		
		
		private function resizeSkin():void
		{
			_bufferWidth = _selfWidth - BUFFER_PADDING;
			if (!_controls) return;
			
			var itemEmpty:DisplayObject;
			var itemFill:DisplayObject;
			
			var storeX:Number = 0;
			
			// LEFT
			itemEmpty = DisplayObject(_bufferEmpty.getChildByName('left'));
			itemFill = DisplayObject(_bufferFill.getChildByName('left'));
			itemEmpty.x = itemEmpty.y = itemFill.x = itemFill.y = 0;
			
			storeX += itemEmpty.width;
			
			// BAR
			itemEmpty = DisplayObject(_bufferEmpty.getChildByName('bar'));
			itemFill = DisplayObject(_bufferFill.getChildByName('bar'));
			itemEmpty.y = itemFill.y = 0;
			itemEmpty.x = storeX;
			itemFill.x = storeX;
			itemEmpty.width = _bufferWidth;
			itemFill.width = _bufferWidth;
			
			storeX += _bufferWidth;
			
			// RIGHT
			itemEmpty = DisplayObject(_bufferEmpty.getChildByName('right'));
			itemFill = DisplayObject(_bufferFill.getChildByName('right'));
			itemEmpty.y = itemFill.y = 0;
			itemEmpty.x = storeX;
			itemFill.x = storeX;
			
			
			
			_play.x = (_controlBar.width - _play.width) / 2;
			_play.y = (_controlBar.height - _play.height) / 2;
			
			_pause.x = (_controlBar.width - _pause.width) / 2;
			_pause.y = (_controlBar.height - _pause.height) / 2;
			
			_skipLeft.x = _play.x - _skipLeft.width * 2;
			_skipLeft.y = (_controlBar.height - _skipLeft.height) / 2;
			
			_skipRight.x = _play.x + _play.width + _skipRight.width;
			_skipRight.y = (_controlBar.height - _skipRight.height) / 2;
			
			
			
			resizeLabels();
			resize();
		}
		
		
		
		private function resizeLabels():void
		{
			_timePlayed.x = _bufferEmpty.x - _timePlayed.width - TIME_PADDING;
			_timeLeft.x = _bufferEmpty.x + _bufferEmpty.width + TIME_PADDING;
			
			_timePlayed.y = (_bufferEmpty.y + _bufferEmpty.height / 2) - _timePlayed.height / 2;
			_timeLeft.y = _timePlayed.y;
		}
		
		
		private function resize(event:Event = null):void
		{
			_bufferWidth = _selfWidth - BUFFER_PADDING;
			if (!_controls) return;
			
			_controls.x = 0;
			_controls.y = 0;
			
			//_timeline.y = Math.round(_selfHeight - _controls.height);
			_controlBar.x = (_selfWidth - _controlBar.width) / 2;
			_controlBar.y = (_selfHeight - _controlBar.height * 1.5);
			
			_timelineBG.x = _timelineBG.y = 0;
			_timelineBG.width = _selfWidth;
			
			_bufferEmpty.x = Math.round((_selfWidth - _bufferEmpty.width) / 2);
			_bufferEmpty.y = Math.round((_timelineBG.height - _bufferEmpty.height) / 2);
			
			_bufferFill.x = _bufferEmpty.x;
			_bufferFill.y = _bufferEmpty.y;
			
			_bufferMask.x = _bufferFill.x;
			_bufferMask.y = _bufferFill.y;
			
			_scrubber.y = _bufferFill.y + _bufferFill.height / 2;
			
			super.x = (_selfWidth - super.width) / 2;
			super.y = (_selfHeight - super.height) / 2;
			
      switch(_align)
      {
				case VideoAlign.TOP: super.y = 0;
					break;
				case VideoAlign.LEFT: super.x = 0;
					break;
				case VideoAlign.RIGHT: super.x = _selfWidth - super.width;
					break;
				case VideoAlign.BOTTOM: super.y = _selfHeight - super.height;
					break;
				case VideoAlign.TOP_LEFT: super.x = 0; super.y = 0;
					break;
				case VideoAlign.TOP_RIGHT: super.x = _selfWidth - super.width; super.y = 0;
					break;
				case VideoAlign.BOTTOM_LEFT: super.x = 0; super.y = _selfHeight - super.height;
					break;
				case VideoAlign.BOTTOM_RIGHT: super.x = _selfWidth - super.width; super.y = _selfHeight - super.height;
					break;
      }
		}
		
		// -------------------------
		
		
		
		private function disposeSkin():void
		{
			if (_bufferTimer) clearFPSTimer(_bufferTimer);
			if (_controls && _controls.parent) _controls.parent.removeChild(_controls);
			if (!_skin) return;
			
			_bufferFill.removeEventListener(MouseEvent.CLICK, envokeSeek);
			_scrubber.removeEventListener(MouseEvent.MOUSE_DOWN, startScrub);
			_timeLeft.removeEventListener(MouseEvent.CLICK, toggleShowTimeState);
			core.api.def.stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrub);
			clearFPSTimer(_scrubTimer);
			
			_skipLeft.removeEventListener(MouseEvent.CLICK, skipLeft);
			_skipRight.removeEventListener(MouseEvent.CLICK, skipRight);
			_play.removeEventListener(MouseEvent.CLICK, playVideo);
			_pause.removeEventListener(MouseEvent.CLICK, pauseVideo);
			
			NetUtils.unload(_skin);
			_skin = null;
		}
		
		private function dispose(event:Event = null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			this.removeEventListener(VideoEvent.READY, construct);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			_trigger.removeEventListener(MouseEvent.DOUBLE_CLICK, toggleFullscreen);
			core.api.def.stage.removeEventListener(Event.RESIZE, resize);
			disposeSkin();
		}
					
					
	}
}
