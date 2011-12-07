package core.media
{
  import core.actions.dynamicFunctionCall;
  import core.api.data.ImageHandler;
  
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.system.LoaderContext;
  
  public dynamic class Image extends ImageHandler
  {
    private var _success:Function;
		private var _failure:Function;
		private var _progress:Function;
		private var _passImage:Boolean;
		private var _data:*;
    
		public static function get(data:* = null, successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null, context:LoaderContext = null):Image
		{
			return new Image(data, successCallback, failureCallback, progressCallback, context, true);
		}
		
		public function get data():* { return _data; }
		
    public function Image(data:* = null, successCallback:Function = null, failureCallback:Function = null, progressCallback:Function = null, context:LoaderContext = null, passImage:Boolean = false):void
    {
      super();
      
      if (data == null) return;
			
			_data = data;
			_passImage = passImage;
      
      if (successCallback != null) _success = successCallback;
      if (failureCallback != null) _failure = failureCallback;
			if (progressCallback != null) _progress = progressCallback;
      
			this.addEventListener(ProgressEvent.PROGRESS, loadingProgress);
      this.addEventListener(Event.COMPLETE, imageLoaded);
      this.addEventListener(IOErrorEvent.IO_ERROR, notFound);
      
      super.loadData(data, context);
    }
    
    
    
    private function clearEvents():void
    {
			this.removeEventListener(ProgressEvent.PROGRESS, loadingProgress);
			this.removeEventListener(Event.COMPLETE, imageLoaded);
      this.removeEventListener(IOErrorEvent.IO_ERROR, notFound);
    }
    
		
		private function loadingProgress(e:ProgressEvent):void
		{
			core.actions.dynamicFunctionCall(_progress, this.percentage);
		}
    
    
    private function imageLoaded(event:Event):void
    {
      clearEvents();
			if (_passImage) core.actions.dynamicFunctionCall(_success, this);
			else            core.actions.dynamicFunctionCall(_success, event);
    }
    
    private function notFound(event:IOErrorEvent):void
    {
      clearEvents();
			core.actions.dynamicFunctionCall(_failure, event);
    }
    
  }
}