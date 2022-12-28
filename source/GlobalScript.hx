package;

import Script;
import assetManagement.LibraryManager;

/** Use this to access/load global scripts. **/
class GlobalScriptRegistry extends ScriptRegistry
{
	static var cache:GlobalScriptRegistry = new GlobalScriptRegistry();
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

	public static function getAsset(id:String):Script
	{
		return LibraryManager.getLibraryAsset(id, cache, true);
	}

	/** Returns all IDs in a library directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("global_scripts", true);
		return cachedIDs;
	}

	public static function startAll()
	{
		for (id in getAllIDs())
			getAsset(id).start();
		callAll("onStart"); // Call an onStart command if one exists
	}

	public static function setAll(name:String, value:Dynamic)
	{
		for (id in getAllIDs())
			getAsset(id).set(name, value);
	}

	public static function callAll(name:String, args:Array<Dynamic> = null)
	{
		for (id in getAllIDs())
			getAsset(id).call(name, args);
	}
}
