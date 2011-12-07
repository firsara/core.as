package core
{
	import core.api.data.AssetHandler;
	public function get assets():AssetHandler
	{
		return (AssetHandler.instance || _.require(AssetHandler) as AssetHandler);
	}
}