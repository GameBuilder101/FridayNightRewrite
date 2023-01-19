package;

import Week;
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
	menuMusicID:String,
	backgroundID:String,
	backgroundColor:FlxColor,
	freeplaySongIDs:Array<String>,
	weeks:Array<WeekData>
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

		/* Week data is loaded in dynamically. Loop through all files with the naming convention "week_#" until
			no more are found. These will be the weeks featured in the album */
		var weeks:Array<WeekData> = [];
		var parsedWeek:Dynamic;
		var i:Int = 0;
		while (true)
		{
			parsedWeek = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/week_" + i);
			if (parsedWeek == null)
				break;
			weeks.push(parsedWeek);
			i++;
		}

		return {
			name: parsed.name,
			description: parsed.description,
			spriteID: parsed.spriteID,
			menuMusicID: parsed.menuMusicID,
			backgroundID: parsed.backgroundID,
			backgroundColor: FlxColor.fromRGB(parsed.backgroundColor[0], parsed.backgroundColor[1], parsed.backgroundColor[2]),
			freeplaySongIDs: parsed.freeplaySongIDs,
			weeks: weeks
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
