package core
{
	import core.net.Location;
	public function get location():Location
	{
		return (Location.instance || _.require(Location) as Location);
	}
}