package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;

/** An album defines a collection of weeks. Useful for if you want a main story
	mode but also extra content grouped into their own thing. **/
typedef AlbumData =
{
	name:String,
	credits:Array<Credit>,
	spriteID:String,
	previewMusicID:String
}

/** Use this to access/load albums. **/
class AlbumRegistry extends Registry<AlbumData>
{
	static var cache:AlbumRegistry = new AlbumRegistry();
	static var cachedIDs:Array<String>;

	function loadData(directory:String, id:String):AlbumData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/album_data");
		if (parsed == null)
			return null;
		return parsed;
	}

	public static function getAsset(id:String):AlbumData
	{
		return LibraryManager.getLibraryAsset("albums/" + id, cache);
	}

	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("albums");
		return cachedIDs;
	}
}
