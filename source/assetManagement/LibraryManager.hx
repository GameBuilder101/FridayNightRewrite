package assetManagement;

import Album;
import AssetSprite;
import SoundData;
import assetManagement.Library;
import assetManagement.Registry;
import music.MusicData;
import stage.Stage;
import sys.FileSystem;

/** Handles the loading, storing, and retrieving of data from libraries. **/
class LibraryManager
{
	/** ID for the core library. **/
	public static inline final CORE_ID:String = "assets";

	/** Directory for mod libraries. **/
	public static inline final MODS_DIRECTORY:String = "mods";

	/** The currently-loaded libraries in memory. Sorted by dependency, with the last having no dependencies. **/
	public static var libraries(default, null):LibraryRegistry = new LibraryRegistry();

	/** Reloads all libraries. **/
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

		preload();
	}

	/** Returns the loaded core library. **/
	public static function getCore():Library
	{
		return cast libraries.get(CORE_ID).data;
	}

	/** Returns the first found instance of an asset with the given id.
		@param cacheRegistry The registry used to cache the type of asset
	**/
	public static function getLibraryAsset<T>(id:String, cacheRegistry:Registry<T>):T
	{
		var entry:RegistryEntry = cacheRegistry.get(id);
		if (entry != null)
			return entry.data;
		for (libraryEntry in libraries.entries)
		{
			entry = cacheRegistry.load(Registry.getFullPath(libraryEntry.directory, libraryEntry.id), id);
			if (entry != null)
				return entry.data;
		}
		trace("Could not locate library asset '" + id + "'!");
		return null;
	}

	/** Returns the IDs of all registry entries from all libraries in the given library-relative directory. **/
	public static function getAllIDs(libraryDirectory:String, includeLibrary:Bool = true):Array<String>
	{
		var all:Array<String> = new Array<String>();
		var fullPath:String;
		var contents:Array<String>;
		// Go through every library
		for (libraryEntry in libraries.entries)
		{
			// Get every file in the provided directory of that library
			fullPath = Registry.getFullPath(libraryEntry.directory, libraryEntry.id);
			contents = FileSystem.readDirectory(fullPath + "/" + libraryDirectory);
			if (contents == null)
				continue;
			var i:Int = 0;
			for (content in contents)
			{
				contents[i] = libraryDirectory + "/" + content;
				if (includeLibrary)
					contents[i] = fullPath + "/" + contents[i];
				if (all.contains(contents[i])) // Clear out any already-added/duplicates
					contents.splice(i, 1);
				else
					i++;
			}
			all = all.concat(contents);
		}
		return all;
	}

	/** Loads in all assets from preload JSON files. **/
	public static function preload()
	{
		var libraryPath:String;
		for (library in libraries.entries)
		{
			libraryPath = Registry.getFullPath(library.directory, library.id);
			preloadFromJSON(libraryPath, "preload_sprites", AssetSpriteRegistry.getAsset);
			preloadFromJSON(libraryPath, "preload_sounds", SoundRegistry.getAsset);
			preloadFromJSON(libraryPath, "preload_music", MusicRegistry.getAsset);
		}
	}

	static inline function preloadFromJSON(libraryPath:String, jsonID:String, loadFunction:String->Void)
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(libraryPath, jsonID));
		if (parsed == null)
			return;
		for (id in cast(parsed, Array<Dynamic>))
			loadFunction(id);
	}

	/** Performs a full reload of all libraries and registries. **/
	public static function fullReload()
	{
		trace("Performing full library reload...");
		reloadLibraries();

		// New registries should get added here!
		ParsedJSONRegistry.reset();
		AssetSpriteRegistry.reset();
		SoundRegistry.reset();
		MusicRegistry.reset();
		StageRegistry.reset();
		AlbumRegistry.reset();

		TransitionManager.updateDefaultTrans();
	}
}
