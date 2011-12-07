package core.utils
{
	public final class NumberUtils
	{
		public static function roundTo(value:Number, target:Number):Number
		{
			return (Math.round(value / target) * target);
		}
	}
}