package core
{
	import core.data.Database;
	
	public function get database():Database
	{
		//if (!_dbInstance) _dbInstance = new Database();
		//return _dbInstance;
		return new Database();
	}
}
