package assetManagement;

import Album;
import assetManagement.Library;

/** Handles the loading, storing, and retrieving of data from libraries. */
class LibraryManager
{
	/** ID for the core library. */
	public static inline final CORE_ID:String = "assets";

	/** Directory for mod libraries. */
	public static inline final MODS_DIRECTORY:String = "mods";

	/** The currently-loaded libraries in memory. Sorted by dependency. */
	public static var libraries(default, null):LibraryRegistry = new LibraryRegistry();

	/** Reloads all libraries. Warning: possibly very laggy */
	public static function reloadLibraries()
	{
		libraries.clear();
		libraries.load("", CORE_ID);
		libraries.loadAll(MODS_DIRECTORY);
		/* Sort libraries based on dependency. If a library has no dependencies, it should be first.
			If a library depends on another, it should be after that one. */
		libraries.entries.sort(function(a, b):Int
		{
			if (cast(a.data, Library).dependsOn(b.id))
				return 1;
			else if (cast(b.data, Library).dependsOn(a.id))
				return -1;
			return 0;
		});
	}

	/** Returns the first found instance of the album with the given id. */
	public static function getAlbum(id:String):AlbumData
	{
		var library:Library;
		for (entry in libraries.getAll())
		{
			library = cast(entry.data, Library);
			if (library.albums.contains(id))
				return cast library.albums.get(id).data;
		}
		return null;
	}
}

/** An alias for LibraryManager. */
typedef Lib = LibraryManager;
