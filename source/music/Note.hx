package music;

import Script;
import assetManagement.LibraryManager;

class Note extends Node
{
	/** The default note type ID. **/
	public static inline final DEFAULT_ID:String = "assets/note_types/normal";

	public var noteType(default, null):Script;

	/** 0 is left, 1 down, 2 up, 3 right **/
	public var lane:Int;

	/** The duration of the sustain note. 0 if not a sustain note. **/
	public var sustain:Float;

	public function new(noteType:Script, time:Float, lane:Int, sustain:Float = 0.0)
	{
		super(time);
		this.noteType = noteType;
		this.lane = lane;
		this.sustain = sustain;
		noteType.start(); // Initialize the type if it hasn't been already
	}

	/** Converts a number representing a note lane into a string representing a note lane. **/
	public static function laneIndexToID(lane:Int):String
	{
		switch (lane)
		{
			case 0:
				return "left";
			case 1:
				return "down";
			case 2:
				return "up";
			default:
				return "right";
		}
	}

	public function onHit(state:PlayState, accuracy:Float)
	{
		noteType.call("onHit", [state, time, lane, accuracy]);
	}

	public function onMiss(state:PlayState)
	{
		noteType.call("onMiss", [state, time, lane]);
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
