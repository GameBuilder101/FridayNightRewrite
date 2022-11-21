package music;

import music.events.*;

/** Handles the conversion of an event type to a string and vice-versa. **/
class MusicEventResolver
{
	/** A list of all valid types of events. **/
	public static final ALL:Array<String> = ["trace"];

	/** Creates a new element from the provided type name and returns it. **/
	public static function resolve(time:Float, type:String, args:Dynamic):MusicEvent
	{
		switch (type)
		{
			case "trace":
				return new TraceEvent(time, args);
		}
		return null;
	}
}
