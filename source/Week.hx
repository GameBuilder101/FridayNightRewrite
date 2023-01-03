package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;

typedef WeekData =
{
	name:String,
	itemName:String,
	previewStageID:String,
	songIDs:Array<String>
}

/** Use this to access/load weeks. **/
class WeekDataRegistry extends Registry<WeekData>
{
	static var cache:WeekDataRegistry = new WeekDataRegistry();
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

	function loadData(directory:String, id:String):WeekData
	{
		return FileManager.getParsedJson(Registry.getFullPath(directory, id));
	}

	public static function getAsset(id:String):WeekData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("weeks");
		return cachedIDs;
	}
}
