package
{
	public function Bool(value:*):Boolean
	{
		switch(String(value).toLowerCase())
		{
			case 'true':
			case 'yes':
			case '1':
				return true;
				
			case 'false':
			case 'no':
			case '0':
				return false;
				
			default: return Boolean(value);
		}
	}
}
