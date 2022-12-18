package assetManagement;

import haxe.Http;
import haxe.Json;

/** A library defines a collection of assets/content (such as a mod). **/
class Library
{
	public var name(default, null):String;
	public var description(default, null):String;

	public var version(default, null):String;

	/** The URL used to find the latest version. **/
	var latestVersionURL:String;

	public var latestVersion(default, null):String = null;

	public var dependencies(default, null):Array<LibraryDependency> = [];

	public function new(name:String, description:String, version:String, latestVersionURL:String, dependencies:Array<LibraryDependency> = null)
	{
		this.name = name;
		this.description = description;
		this.version = version;
		this.latestVersionURL = latestVersionURL;
		this.dependencies = dependencies;
		if (dependencies == null)
			this.dependencies = [];

		getLatestVersion();
	}

	function getLatestVersion()
	{
		if (latestVersionURL == null)
			return;
		trace("Getting latest version for library '" + name + "'...");

		var http:Http = new Http(latestVersionURL);
		http.onData = function(data:String)
		{
			var s:Dynamic = Json.parse(data);
			if (s == null || s.version == null)
			{
				trace("Error! Could not find latest version for library '" + name + "': JSON data was malformed");
				return;
			}
			trace("Found GitHub version for library '" + name + "': '" + s.version + "'");
			latestVersion = version;
		}
		http.onError = function(msg)
		{
			trace("Error! Could not find latest version for library '" + name + "': " + msg);
		}

		http.request();
	}

	public inline function isOutdated():Bool
	{
		return latestVersion != null && version != latestVersion;
	}

	/** Returns true if a library of the given ID is a dependency. **/
	public function dependsOn(id:String):Bool
	{
		for (dependency in dependencies)
		{
			if (dependency.id == id)
				return true;
		}
		return false;
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
	function loadData(directory:String, id:String):Library
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/library");
		if (parsed == null)
			return null;
		trace("Loaded library '" + id + "'");
		return new Library(parsed.name, parsed.description, parsed.version, parsed.latestVersionURL, parsed.dependencies);
	}
}
