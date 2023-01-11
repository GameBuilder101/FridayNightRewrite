package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;

typedef SongData =
{
	name:String,
	characterTags:Array<String>,
	stageID:String,
	playerID:String,
	girlfriendID:String,
	opponentID:String,
	playerVariant:String,
	opponentVariant:String,
	girlfriendVariant:String
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
		return FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/song_data");
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
