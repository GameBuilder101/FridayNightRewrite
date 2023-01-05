package music;

/** Used to refer to any type of chart. **/
class Chart<T:Node>
{
	public var nodes:Array<T> = [];

	public function new(nodes:Array<T>)
	{
		this.nodes = nodes;
	}
}
