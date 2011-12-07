package
{
	import core.utils.ObjectUtils;

	public function print_r(obj:*):void
	{
		ObjectUtils.deepTrace(obj);
	}
}