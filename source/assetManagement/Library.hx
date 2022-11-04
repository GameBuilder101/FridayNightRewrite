package assetManagement;

import Album;
import haxe.Json;

/** A library defines a collection of assets/content (such as a mod). **/
class Library
{
	public var name(default, null):String;
	public var description(default, null):String;
	public var version(default, null):String;
	public var dependencies(default, null):Array<LibraryDependency> = [];

	public var albums(default, null):AlbumRegistry = new AlbumRegistry();

	public function new(name:String, description:String, version:String, dependencies:Array<LibraryDependency>)
	{
		this.name = name;
		this.description = description;
		this.version = version;
		this.dependencies = dependencies;
	}
}

/** Tells what other library is required for a library to work. **/
typedef LibraryDependency =
{
	id:String,
	suggestedVersion:String
}

class LibraryRegistry extends Registry<Library>
{
	function loadData(path:String):Library
	{
		var parsed:Dynamic = Paths.getParsedJson(path + "/library");
		if (parsed == null)
			return null;

		// Load the dependencies as an array of LibraryDependency
		var dependencies:Array<LibraryDependency> = new Array<LibraryDependency>();
		for (dependency in cast(parsed.dependencies, Array<Dynamic>))
			dependencies.push(dependency);

		// Create the library from the initial JSON information
		var library:Library = new Library(parsed.name, parsed.description, parsed.version, dependencies);

		// Load registries
		library.albums.loadAll(path + "/" + AlbumRegistry.LIBRARY_DIRECTORY);

		// Return the created library
		return library;
	}
}
