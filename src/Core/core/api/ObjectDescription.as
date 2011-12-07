package core.api
{
	[ExcludeClass]
	public final class ObjectDescription
	{
		private var _staticMethods:Array;
		private var _staticProperties:Array;
		private var _memberMethods:Array;
		private var _memberProperties:Array;
		
		public function get staticMethods()     :  Array { return _staticMethods; }
		public function get staticProperties()  :  Array { return _staticProperties; }
		public function get memberMethods()     :  Array { return _memberMethods; }
		public function get memberProperties()  :  Array { return _memberProperties; }
		
		
		public function ObjectDescription(staticMethods    : Array,
																			staticProperties : Array,
																			memberMethods    : Array,
																			memberProperties : Array)
		{
			_staticMethods     =  staticMethods; 
			_staticProperties  =  staticProperties;
			_memberMethods     =  memberMethods;
			_memberProperties  =  memberProperties;
		}
	}
}