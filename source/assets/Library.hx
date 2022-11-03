package assets;

import Album;
import haxe.Json;
import sys.io.File;

/** A library defines a collection of assets/content (such as a mod). **/
class Library
{
	/** The path where the library is sourced from. **/
	public var path(default, null):String;

	public var name(default, null):String;
	public var description(default, null):String;
	public var credits(default, null):Array<Credit> = [];

	public var albums(default, null):AlbumRegistry;

	public function new(path:String)
	{
		this.path = path;

		// First, get the parsed main library JSON to fill out the basic library information
		var parsed:Dynamic = Json.parse(File.getContent(path + "/library.json"));
		name = parsed.name;
		description = parsed.description;
		for (credit in cast(parsed.credits, Array<Dynamic>)) // Generate credits from dynamic data
			credits.push({name: credit.name, role: credit.role});

		// Load registries
		albums.loadFromDirectory(path + "/albums");
	}
}

typedef Credit =
{
	name:String,
	role:String
}

class LibraryRegistry extends Registry<Library>
{
	function loadData(path:String):Library
	{
		return new Library(path);
	}
}
