package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.util.FlxColor;

typedef SongData =
{
	name:String,
	// In case a mod wants to add custom difficulties
	difficulties:Array<SongDifficulty>,
	singers:Array<String>,
	eventsID:String,
	stageID:String,
	opponentID:String
}

typedef SongDifficulty =
{
	name:String,
	color:FlxColor
}

/** Use this to access/load songs. **/
class SongDataRegistry extends Registry<SongData>
{
	static var cache:SongDataRegistry = new SongDataRegistry();
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

	function loadData(directory:String, id:String):SongData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/song_data");
		if (parsed == null)
			return null;

		var difficulties:Array<SongDifficulty> = [];
		for (difficulty in cast(parsed.difficulties, Array<Dynamic>))
		{
			difficulties.push({
				name: difficulty.name,
				color: FlxColor.fromRGB(difficulty.color[0], difficulty.color[1], difficulty.color[2], difficulty.color[3])
			});
		}

		return {
			name: parsed.name,
			difficulties: difficulties,
			singers: parsed.singers,
			eventsID: parsed.eventsID,
			stageID: parsed.stageID,
			opponentID: parsed.opponentID
		};
	}

	public static function getAsset(id:String):SongData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("songs");
		return cachedIDs;
	}
}
