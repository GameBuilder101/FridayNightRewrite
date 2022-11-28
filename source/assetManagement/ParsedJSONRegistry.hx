package assetManagement;

/** Use this to access/load generic, standalone JSON files. **/
class ParsedJSONRegistry extends Registry<Dynamic>
{
	static var cache:ParsedJSONRegistry = new ParsedJSONRegistry();

	function loadData(directory:String, id:String):Dynamic
	{
		return FileManager.getParsedJson(Registry.getFullPath(directory, id));
	}

	public static function getAsset(id:String):Dynamic
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Resets the cache. **/
	public static function reset()
	{
		cache.clear();
	}
}
