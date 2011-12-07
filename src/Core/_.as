package
{
  public class _
  {
    public static function require(extension:Class, requireOnce:Boolean = false):*
		{
			try
			{
				if (requireOnce)
				{
					if (extension['require'] != null)
					{
						try { extension['require'](); } catch(e:Error) {}
					}
				}
				else
				{
					return extension['require']();
				}
			}
			catch(e:Error)
			{
				trace(extension + ' not enabled for require');
			}
			
			return null;
		}
		
		
		public static function require_once(extension:Class):*
		{
			return require(extension, true);
		}
  }
}