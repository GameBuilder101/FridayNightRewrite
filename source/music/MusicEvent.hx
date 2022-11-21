package music;

abstract class MusicEvent
{
	/** The time this event triggers. **/
	public var time(default, null):Float;

	var args:Dynamic;

	public function new(time:Float, args:Dynamic)
	{
		this.time = time;
		this.args = args;
	}

	/** Triggers the event. **/
	public abstract function trigger(state:ConductedState):Void;
}
