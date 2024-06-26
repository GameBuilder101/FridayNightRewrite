package assetManagement;

/** This is a way of loading a type of "thing" from the files and storing it in a list for later use.
	For instance, you could have a registry of all characters in the game. Each entry has an "ID", used to
	identify it. For instance, "joe" might be the character Joe's ID. **/
abstract class Registry<T>
{
	/** Stores the currently loaded registry entries. **/
	public var entries(default, null):Array<RegistryEntry> = [];

	public function new() {}

	/** Returns the full entry path (excluding the file extension). **/
	public static inline function getFullPath(directory:String, id:String):String
	{
		if (directory != "")
			return directory + "/" + id;
		return id;
	}

	/** Loads a specific entry of the given ID from the directory. **/
	public function load(directory:String, id:String):RegistryEntry
	{
		var data:T = loadData(directory, id);
		if (data == null)
			return null;
		entries.push({directory: directory, id: id, data: data});
		return entries[entries.length - 1];
	}

	/** Create a new T from the data/files provided in the entry directory.
		@return A new instance of T generated from the data/files found in the directory at path. If null, the entry is not added.
	**/
	abstract function loadData(directory:String, id:String):T;

	/** Removes a loaded entry of the given id. **/
	public function remove(id:String)
	{
		for (entry in entries)
		{
			if (entry.id == id)
				entries.remove(entry);
		}
	}

	/** Clears all loaded entries from memory. **/
	public function clear()
	{
		entries = [];
	}

	/** Returns true if this contains the entry with the given id. **/
	public function contains(id:String):Bool
	{
		for (entry in entries)
		{
			if (entry.id == id)
				return true;
		}
		return false;
	}

	/** Returns the entry with the given id. **/
	public function get(id:String):RegistryEntry
	{
		for (entry in entries)
		{
			if (entry.id == id)
				return entry;
		}
		return null;
	}
}

typedef RegistryEntry =
{
	directory:String,
	id:String,
	data:Dynamic
}
