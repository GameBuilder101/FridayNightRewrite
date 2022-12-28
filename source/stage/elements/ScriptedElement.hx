package stage.elements;

import Script;
import assetManagement.LibraryManager;

/** An element which uses a script to extend functionality. **/
class ScriptedElement extends GeneralSpriteElement
{
	var elementType:Script;

	public function new(elementType:Script, data:Dynamic)
	{
		super(data);
		this.elementType = elementType;
		elementType.start();
		// Allow access to this sprite's data
		elementType.set("this", this);
		// Call a "onNew" function and pass in the data so the script can do what it wants with it
		elementType.call("onNew", [data]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		elementType.call("onUpdate", [elapsed]);
	}

	override function onAddedToStage(stage:Stage)
	{
		super.onAddedToStage(stage);
		elementType.call("onAddedToStage", [stage]);
	}

	override function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		super.updateMusic(time, bpm, beat);
		elementType.call("onUpdateMusic", [time, bpm, beat]);
	}

	override function onWholeBeat(beat:Int)
	{
		super.onWholeBeat(beat);
		elementType.call("onWholeBeat", [beat]);
	}
}

/** Use this to access/load scripted stage element types. **/
class ScriptedElementTypeRegistry extends ScriptRegistry
{
	static var cache:ScriptedElementTypeRegistry = new ScriptedElementTypeRegistry();
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
		cachedIDs = LibraryManager.getAllIDs("stage_elements", true);
		return cachedIDs;
	}
}
