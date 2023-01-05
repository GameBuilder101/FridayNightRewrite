package music;

import Script;
import assetManagement.LibraryManager;

class Event extends Node
{
	public var eventType(default, null):Script;

	var args:Dynamic;

	public function new(eventType:Script, time:Float, args:Dynamic)
	{
		super(time);
		this.eventType = eventType;
		this.args = args;
		eventType.start(); // Initialize the type if it hasn't been already
	}

	/** Triggers the event. **/
	public function trigger(state:ConductedState)
	{
		eventType.call("onTrigger", [state, time, args]);
	}
}

/** Use this to access/load event types. **/
class EventTypeRegistry extends ScriptRegistry
{
	static var cache:EventTypeRegistry = new EventTypeRegistry();
	static var cachedIDs:Array<String>;

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
			cachedIDs = [];
		});
	}

	public static function getAsset(id:String):Script
	{
		return cast LibraryManager.getLibraryAsset(id, cache, true);
	}

	/** Returns all IDs in a library directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("event_types", true);
		return cachedIDs;
	}
}
