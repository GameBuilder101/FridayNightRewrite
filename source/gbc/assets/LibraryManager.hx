package gbc.assets;

import sys.FileSystem;

class LibraryManager
{
	/** The main library registry. **/
	public static var registry(default, null):LibraryRegistry = new LibraryRegistry("assets");

	/** A list of all currently-loaded libraries. **/
	public static var all(default, null):Array<Library> = [];

	/** Reloads all libraries. **/
	public static function reloadAll()
	{
		registry.clearCache();
		all = [];
		for (id in FileSystem.readDirectory(registry.source))
			all.push(registry.get(id));

		/* Sort libraries based on dependency. If a library has no dependencies, it should be last.
			If a library depends on another, it should be before that one */
		all.sort(function(a, b):Int
		{
			if (a.dependsOn(registry.getID(b)))
				return -1;
			else if (b.dependsOn(registry.getID(a)))
				return 1;
			return 0;
		});

		var library:Library;
		// Remove a library if it is missing dependencies
		for (library in all)
		{
			for (dependency in library.dependencies)
			{
				if (registry.get(dependency.id) != null)
					continue;
				trace("Warning: Removed library '" + registry.getID(library) + "' because it was missing dependency '" + dependency.id + "'!");
				all.remove(library);
				break;
			}
		}
	}

	/** @param cl The registry type. **/
	public static function getAsset(id:String, cl:Class<Dynamic>):Dynamic
	{
		var item:Dynamic;
		for (library in all)
		{
			item = library.getAsset(id, cl);
			if (item != null)
				return item;
		}
		return null;
	}

	/** Gets the ID of a loaded item. Returns null if one cannot be found.
		@param cl The registry type.
	**/
	public static function getAssetID(item:Dynamic, cl:Class<Dynamic>):String
	{
		var id:String;
		for (library in all)
		{
			id = library.getAssetID(item, cl);
			if (id != null)
				return id;
		}
		return null;
	}

	public static function clearAssetCache()
	{
		for (library in all)
			library.clearAssetCache();
	}
}
