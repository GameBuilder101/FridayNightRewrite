package music;

/** A generic thing to reference something in a chart (meaning either a note or an event). **/
class Node
{
	/** The time of this node in the music. **/
	public var time(default, null):Float;

	public function new(time:Float)
	{
		this.time = time;
	}
}
