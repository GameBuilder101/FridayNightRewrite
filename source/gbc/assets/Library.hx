package gbc.assets;

import haxe.Http;
import haxe.Json;

using StringTools;

class Library
{
	public var name:String;
	public var description:String = "";
	public var version:String = "";
	public var latestVersionURL(default, null):String = "";

	/** The latest version of the library, assuming a latestVersionURL was provided and found. **/
	public var latestVersion(default, null):String = "";

	public var dependencies:Array<LibraryDependency> = [];

	var registries:Array<Registry<Dynamic>> = [];

	public function new(name:String, description:String, version:String, latestVersionURL:String = null, dependencies:Array<LibraryDependency> = null)
	{
		this.name = name;
		if (description != null)
			this.description = description;
		if (version != null)
			this.version = version;
		if (latestVersionURL != null)
		{
			this.latestVersionURL = latestVersionURL;
			getLatestVersion();
		}
		if (dependencies != null)
			this.dependencies = dependencies;
	}

	function getLatestVersion()
	{
		trace("Getting latest version for library '" + name + "'...");

		var http:Http = new Http(latestVersionURL);
		http.onData = function(data:String)
		{
			var jsonData:Dynamic = Json.parse(data);
			if (jsonData == null || jsonData.version == null)
			{
				trace("Error! Could not find latest version for library '" + name + "': JSON data was malformed");
				return;
			}
			trace("Found GitHub version for library '" + name + "': '" + jsonData.version + "'");
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
		return version != latestVersion;
	}

	public function dependsOn(id:String):Bool
	{
		for (dependency in dependencies)
		{
			if (dependency.id == id)
				return true;
		}
		return false;
	}

	/** @param cl The registry type. **/
	public function getAsset(id:String, cl:Class<Dynamic>):Dynamic
	{
		for (registry in registries)
		{
			if (Std.isOfType(registry, cl))
				return registry.get(id);
		}
		// Add an instance of the registry if there isn't one yet
		registries.push(Type.createInstance(cl, [LibraryManager.registry.source + LibraryManager.registry.getID(this)]));
		return registries[registries.length - 1].get(id);
	}

	/** Gets the ID of a loaded item. Returns null if one cannot be found.
		@param cl The registry type.
	**/
	public function getAssetID(item:Dynamic, cl:Class<Dynamic>):String
	{
		for (registry in registries)
		{
			if (Std.isOfType(registry, cl))
				return registry.getID(item);
		}
		return null;
	}

	public function clearAssetCache()
	{
		for (registry in registries)
			registry.clearCache();
	}
}

typedef LibraryDependency =
{
	id:String,
	version:String
}
