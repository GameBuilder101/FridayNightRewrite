package assetManagement;

/** A library defines a collection of assets/content (such as a mod). **/
class Library
{
	public var name(default, null):String;
	public var description(default, null):String;
	public var version(default, null):String;
	public var dependencies(default, null):Array<LibraryDependency> = [];

	public function new(name:String, description:String, version:String, dependencies:Array<LibraryDependency>)
	{
		this.name = name;
		this.description = description;
		this.version = version;
		this.dependencies = dependencies;
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

		// Fill in default values if the data is missing
		if (parsed.dependencies == null)
			parsed.dependencies = [];

		trace("Loaded library '" + id + "'");
		return new Library(parsed.name, parsed.description, parsed.version, parsed.dependencies);
	}
}
