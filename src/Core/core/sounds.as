package core
{
	import core.media.SoundHandler;
	public function get sounds():SoundHandler
	{
		return (SoundHandler.instance || _.require(SoundHandler) as SoundHandler);
	}
}