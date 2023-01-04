package music;

import Script;
import assetManagement.LibraryManager;

class Note extends Node
{
	public var noteType(default, null):Script;

	public function new(noteType:Script, time:Float, args:Dynamic)
	{
		super(time, args);
		this.noteType = noteType;
		noteType.start(); // Initialize the type if it hasn't been already
	}

	public function onHit(state:ConductedState)
	{
		noteType.call("onHit", [state, time]);
	}

	public function onMiss(state:ConductedState)
	{
		noteType.call("onMiss", [state, time]);
	}
}

/** Use this to access/load note types. **/
class NoteTypeRegistry extends ScriptRegistry
{
	static var cache:NoteTypeRegistry = new NoteTypeRegistry();
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
		cachedIDs = LibraryManager.getAllIDs("note_types", true);
		return cachedIDs;
	}
}
