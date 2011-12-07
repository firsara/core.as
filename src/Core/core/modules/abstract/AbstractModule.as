package core.modules.abstract
{
	import core.template.AbstractTemplate;
	import core.template.IAbstractTemplate;

	public class AbstractModule
		extends AbstractTemplate
		implements IModule, IAbstractTemplate
	{
		override public function render():void
		{
			super.render();
		}
		
		public function AbstractModule()
		{
		}
	}
}