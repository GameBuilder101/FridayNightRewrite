package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.util.FlxColor;

typedef CharacterData =
{
	name:String,
	variants:Array<CharacterVariant>,
	menuSpriteID:String,
	themeColor:FlxColor
}

typedef CharacterVariant =
{
	id:String,
	spriteID:String
}

/** Use this to access/load character data. **/
class CharacterDataRegistry extends Registry<CharacterData>
{
	static var cache:CharacterDataRegistry = new CharacterDataRegistry();
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

	function loadData(directory:String, id:String):CharacterData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/character_data");
		if (parsed == null)
			return null;
		return {
			name: parsed.name,
			variants: parsed.variants,
			menuSpriteID: parsed.menuSpriteID,
			themeColor: FlxColor.fromRGB(parsed.themeColor[0], parsed.themeColor[1], parsed.themeColor[2])
		};
	}

	public static function getAsset(id:String):CharacterData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("characters");
		return cachedIDs;
	}
}
