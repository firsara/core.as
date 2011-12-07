package core.data
{
	import flash.data.SQLResult;

	public class DatabaseResult extends SQLResult
	{
		public function get empty():Boolean
		{
			if (super.data == null) return true;
			if (super.data.length == 0) return true;
			return false;
		}
		
		public function DatabaseResult(data:Array = null, rowsAffected:Number = 0, complete:Boolean = true, rowID:Number = 0):void
		{
			super(data, rowsAffected, complete, rowID);
		}
	}
}