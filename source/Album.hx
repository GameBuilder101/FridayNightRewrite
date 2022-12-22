package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.util.FlxColor;

/** An album defines a collection of weeks. Useful for if you want a main story
	mode but also extra content grouped into their own thing. **/
typedef AlbumData =
{
	name:String,
	description:String,
	spriteID:String,
	spriteSpinSpeed:Float,
	backgroundColor:FlxColor,
	previewMusicID:String
}

/** Use this to access/load albums. **/
class AlbumDataRegistry extends Registry<AlbumData>
{
	static var cache:AlbumDataRegistry = new AlbumDataRegistry();
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

	function loadData(directory:String, id:String):AlbumData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/album_data");
		if (parsed == null)
			return null;

		if (parsed.spriteSpinSpeed == null)
			parsed.spriteSpinSpeed = 0.3;

		return {
			name: parsed.name,
			description: parsed.description,
			spriteID: parsed.spriteID,
			spriteSpinSpeed: parsed.spriteSpinSpeed,
			backgroundColor: FlxColor.fromRGB(parsed.backgroundColor[0], parsed.backgroundColor[1], parsed.backgroundColor[2]),
			previewMusicID: parsed.previewMusicID
		};
	}

	public static function getAsset(id:String):AlbumData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("albums");
		return cachedIDs;
	}
}
