package
{
	public function isClass(object:*):Boolean
	{
		return (String(object).indexOf('[class') != -1);
	}
}