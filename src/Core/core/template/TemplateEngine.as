package core.template
{
	import core.media.Image;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class TemplateEngine
	{
		private var _holder:Sprite;
		private var _preloader:ITemplatePreloader;
		private var _template:AbstractTemplate;
		private var _newTemplate:AbstractTemplate;
		private var _templateLoader:Image;
		private var _parameters:Object;
		
		public function get template():AbstractTemplate
		{
			return _template;
		}
		
		public function get preloader():ITemplatePreloader { return _preloader; }
		public function set preloader(value:ITemplatePreloader):void
		{
			_preloader = value;
		}
		
		public function get holder():Sprite { return _holder; }
		public function set holder(value:Sprite):void
		{
			_holder = value;
			if (_template && !_template.holder.parent) _holder.addChild(_template.holder);
		}
		
		public function add(template:*, parameters:Object = null):void
		{
			_parameters = parameters;
			
			if (template is String)
			{
				_templateLoader = Image.get(template, fetch, fail, null, new LoaderContext(true, new ApplicationDomain()));
				_templateLoader.addEventListener(Event.ENTER_FRAME, setPreloader);
				
				_newTemplate = new AbstractTemplate();
				_newTemplate.parameters = parameters;
				_newTemplate.holder.addChild(_templateLoader);
			}
			else if (template is DisplayObject)
			{
				_newTemplate = new AbstractTemplate();
				_newTemplate.parameters = parameters;
				_newTemplate.holder.addChild(template as DisplayObject);
				addTemplate();
			}
			else if (template is Class)
			{
				var target:* = new (template as Class)();
				if (target is AbstractTemplate)
				{
					_newTemplate = (target as AbstractTemplate);
				}
				else
				{
					_newTemplate = new AbstractTemplate();
					_newTemplate.holder.addChild(target);
				}
				
				_newTemplate.parameters = parameters;
				addTemplate();
			}
			else
			{
				trace(typeof(template) + ' not supported as Template');
			}
		}
		
		private function addTemplate():void
		{
			if (_template && _template.holder.parent) _template.holder.parent.removeChild(_template.holder);
			if (_template) _template.die();
			if (_holder) _holder.addChild(_newTemplate.holder);
			
			if (_templateLoader)
			{
				_templateLoader.removeEventListener(Event.ENTER_FRAME, setPreloader);
				_templateLoader.unload();
			}
			
			_template = null;
			_templateLoader = null;
			
			
			_template = _newTemplate;
			_template.render();
		}
		
		
		private function setPreloader():void
		{
			if (_preloader && _templateLoader) _preloader.set(_templateLoader.percentage);
		}
		
		private function fetch(e:Event):void
		{
			try { _templateLoader.content.parameters = _parameters; } catch(e:Error) {}
			try { _templateLoader.content.render();                 } catch(e:Error) {}
			
			addTemplate();
		}
		
		private function fail(e:IOErrorEvent):void
		{
			trace('template could not be loaded');
		}
		
		public function TemplateEngine()
		{
		}
	}
}