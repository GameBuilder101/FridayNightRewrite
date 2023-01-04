package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.util.FlxColor;

typedef Difficulty =
{
	name:String,
	color:FlxColor
}

/** Use this to access/load difficulties. **/
class DifficultyRegistry extends Registry<Difficulty>
{
	static var cache:DifficultyRegistry = new DifficultyRegistry();
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

	function loadData(directory:String, id:String):Difficulty
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id));
		if (parsed == null)
			return null;
		return {
			name: parsed.name,
			color: FlxColor.fromRGB(parsed.color[0], parsed.color[1], parsed.color[2])
		};
	}

	public static function getAsset(id:String):Difficulty
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("difficulties");
		return cachedIDs;
	}
}
