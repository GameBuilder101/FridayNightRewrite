package assetManagement;

import Album;
import assetManagement.Library;

/** Handles the loading, storing, and retrieving of data from libraries. **/
class LibraryManager
{
	/** ID for the core library. **/
	public static inline final CORE_ID:String = "assets";

	/** Directory for mod libraries. **/
	public static inline final MODS_DIRECTORY:String = "mods";

	/** The currently-loaded libraries in memory. Sorted by dependency, with the last having no dependencies. **/
	public static var libraries(default, null):LibraryRegistry = new LibraryRegistry();

	/** Reloads all libraries. Warning: possibly very laggy **/
	public static function reloadLibraries()
	{
		libraries.clear();

		libraries.loadAll(MODS_DIRECTORY);
		/* Sort libraries based on dependency. If a library has no dependencies, it should be last.
			If a library depends on another, it should be before that one. */
		libraries.entries.sort(function(a, b):Int
		{
			if (cast(a.data, Library).dependsOn(b.id))
				return -1;
			else if (cast(b.data, Library).dependsOn(a.id))
				return 1;
			return 0;
		});
		var library:Library;
		// Remove a library if it is missing dependencies
		for (entry in libraries.entries)
		{
			library = cast(entry.data, Library);
			for (dependency in library.dependencies)
			{
				if (!libraries.contains(dependency.id))
				{
					trace("Warning: Removed library '" + entry.id + "' because it was missing dependency '" + dependency.id + "'!");
					libraries.remove(entry.id);
					break;
				}
			}
		}

		libraries.load("", CORE_ID);
	}

	/** Returns the first found instance of the album with the given id. **/
	public static function getAlbum(id:String):AlbumData
	{
		var library:Library;
		for (entry in libraries.entries)
		{
			library = cast(entry.data, Library);
			if (library.albums.contains(id))
				return cast library.albums.get(id).data;
		}
		return null;
	}
}

/** An alias for LibraryManager. **/
typedef Lib = LibraryManager;
