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

	public static var libraries(default, null):LibraryRegistry = new LibraryRegistry();

	/** Reloads all libraries. Warning: possibly very laggy **/
	public static function reloadLibraries()
	{
		libraries.clear();
		libraries.loadAll(MODS_DIRECTORY);
		/* Load the core assets after the mods so that mod content gets prioritized (therefore,
			overloaded assets get used instead.) */
		libraries.load("", CORE_ID);
	}

	/** Returns the first found instance of the album with the given id. **/
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

/** An alias for LibraryManager. **/
typedef Lib = LibraryManager;
