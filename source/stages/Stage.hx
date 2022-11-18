package stages;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.group.FlxSpriteGroup;

typedef StageData =
{
	name:String,
	elements:Array<StageElementData>
}

typedef StageElementData =
{
	name:String,
	type:String,
	x:Float,
	y:Float,
	scale:Float,
	rotation:Float,
	data:Dynamic
}

/** Use this to access/load stages. **/
class StageRegistry extends Registry<StageData>
{
	static var cache:StageRegistry = new StageRegistry();
	static var cachedIDs:Array<String>;

	function loadData(directory:String, id:String):StageData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/stage_data");
		if (parsed == null)
			return null;
		return parsed;
	}

	public static function getAsset(id:String):StageData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("stages");
		return cachedIDs;
	}
}

/** Stages are collections of stage elements put together from a JSON file. They are used for backgrounds in things like songs and menus. **/
class Stage extends FlxSpriteGroup
{
	public var data(default, null):StageData;

	/**
		@param data Data to be loaded on creation.
		@param id When supplied, the stage data will be retrieved via StageRegistry.getAsset.
	**/
	public function new(x:Float, y:Float, ?data:StageData = null, ?id:String = null)
	{
		super(x, y);
		if (data != null)
			loadFromData(data);
		else if (id != null)
		{
			var foundData:StageData = StageRegistry.getAsset(id);
			if (foundData != null)
				loadFromData(foundData);
		}
	}

	/** Loads the stage information and creates elements from the provided data. **/
	public function loadFromData(data:StageData)
	{
		this.data = data;
	}
}

interface StageElement {}
