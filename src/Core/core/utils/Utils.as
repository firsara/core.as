package core.utils
{
	import core.api.Mixin;
	
	public dynamic final class Utils
	{
		private static var self:Class = prototype.constructor;
		Mixin.extendClass(self, ArrayUtils);
		Mixin.extendClass(self, Convert);
		Mixin.extendClass(self, DisplayUtils);
		Mixin.extendClass(self, ObjectUtils);
		Mixin.extendClass(self, StringUtils);
		Mixin.extendClass(self, Time);
		
		public function Utils()
		{
		}
	}
}