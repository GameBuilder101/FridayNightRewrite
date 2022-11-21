package music.events;

/** This is for testing purposes. **/
class TraceEvent extends MusicEvent
{
	public function trigger(state:ConductedState)
	{
		trace(args.message);
	}
}
