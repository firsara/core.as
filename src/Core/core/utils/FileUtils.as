package core.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileUtils
	{
		public static function read(file:*):String
		{
			var stream:FileStream = new FileStream();
			
			try
			{
				stream.open(fetch(file), FileMode.READ);
			}
			catch(e:Error)
			{
				return '';
			}
			
			var output:String = stream.readUTF();
			stream.close();
			return output;
		}
		
		
		public static function write(file:*, value:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(fetch(file), FileMode.WRITE);
			stream.writeUTF(value);
			stream.close();
		}
		
		public static function update(file:*, value:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(fetch(file), FileMode.APPEND);
			stream.writeUTF(value);
			stream.close();
		}
		
		
		
		public static function fetch(file:*):File
		{
			if (file is File)
			{
				return (file as File);
			}
			else if (file is String)
			{
				return ((new File()).resolvePath(String(file)));
			}
			else
			{
				throw new Error('only String and File supported');
			}
		}
		
	}
}