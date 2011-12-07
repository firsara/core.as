package core.api.data
{
	import core.utils.NetUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public dynamic class ImageHandler extends Sprite
  {
		public var catchError:Boolean = false;
		
		private var _content:*;
		private var _bitmap:Bitmap;
		private var _queue:Array;
		private var _images:Array;
		
		private var _imageLoader:Loader;
		private var _request:URLRequest;
		private var _context:LoaderContext;
		
		private var _queuedImage:ImageHandler;
		private var _queueLength:int;
		
		
		public function ImageHandler() {
			_queue = new Array();
			_images = new Array();
		}
		
		
		
		public function push(path:String):void {
			_queue.push(path);
		}
		
		
		
		// GETTER & SETTER
		public function get percentage():Number
		{
			var p:Number = _queuedImage._imageLoader.contentLoaderInfo.bytesLoaded / _queuedImage._imageLoader.contentLoaderInfo.bytesTotal;
			if (_queueLength)
			{
				return ((_images.length - 1 + p) / _queueLength);
			}
			
			return (p);
		}
		
		public function get bitmap():Bitmap { return _bitmap; }
		
		public function get content():*     { return _content; }
		
		public function get queue():Array   { return _queue; }
		public function set queue(queue:Array):void {
			_queue = queue;
		}
		
		public function get images():Array {
			return _images;
		}
		
		
		
		
		// Loading functions
		
		public function load(path:String, context:LoaderContext = null):void
    {
			initLoading(context);
			_request = new URLRequest(NetUtils.recache(path));
			_imageLoader.load(_request, context);
		}
		
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			initLoading(context);
			_imageLoader.loadBytes(bytes, context);
		}
		
		public function loadQueue(queue:Array = null, context:LoaderContext = null):void
    {
			if (queue != null) this._queue = queue;
			_queueLength = this._queue.length;
			loadNextImage();
		}
		
		
		public function loadData(data:*, context:LoaderContext = null):void
		{
			if      (data is Array)     loadQueue(data as Array, context);
			else if (data is ByteArray) loadBytes(data, context);
			else                        load(data, context);
		}
		
		
		
		
		public function unload():void
		{
			if (_queue) for each (var image:ImageHandler in _queue) image.unload();
			
			if (_imageLoader) NetUtils.unload(_imageLoader);
			
			_imageLoader = null;
			
			_content = null;
			_bitmap = null;
			_queue = null;
			_images = null;
			_request = null;
			_context = null;
		}
		
		

		
		// INITIALIZE LOADER AND EVENTS
		private function initLoading(context:LoaderContext):void
		{
			_context = context;
			
			_imageLoader = new Loader();
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, progressImage);
			_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, notFound);
			_imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, dispatchProgress);
			
			_queuedImage = this;
		}
		
		
		private function removeEvents(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, progressImage);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, notFound);
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, dispatchProgress);
		}
		
		
		
		
		// EVENTS
		private function progressImage(event:Event):void
		{
			removeEvents(event);
			_queuedImage = null;
			
			if (event.target.content is Bitmap)
			{
				_bitmap = Bitmap(event.target.content);
				_bitmap.smoothing = true;
				_content = _bitmap;
			}
			else
			{
				_content = DisplayObject(event.target.content);
			}
			
			_images.push(this);
			this.addChild(_content);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function notFound(event:IOErrorEvent):void
		{
			removeEvents(event);
			if(!catchError) this.dispatchEvent(event);
		}
		
		private function dispatchProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}
		
		
		
		// QUEUE EVENT FUNCTIONS
		private function loadNextImage(event:Event = null):void
		{
			if (event)
			{
				event.currentTarget.removeEventListener(Event.COMPLETE, loadNextImage);
				event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, dispatchProgress);
			}
			
			if (_queue.length > 0)
			{
				_queuedImage = new ImageHandler();
				_queuedImage.addEventListener(Event.COMPLETE, loadNextImage);
				_queuedImage.addEventListener(ProgressEvent.PROGRESS, dispatchProgress);
				_queuedImage.catchError = this.catchError;
				
				_queuedImage.loadData(_queue[0], _context);
				
				_images.push(_queuedImage);
				_queue.shift();
			}
			else
			{
				_queuedImage = null;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}

