package music;

/** A generic thing to reference something in a chart (meaning either a note or an event). **/
class Node
{
	/** The time of this node in the music. **/
	public var time(default, null):Float;

	/** Holds things such as event arguments, note lanes, etc. **/
	var args:Dynamic;

	public function new(time:Float, args:Dynamic)
	{
		this.time = time;
		this.args = args;
	}
}
