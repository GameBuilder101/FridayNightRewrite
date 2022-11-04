package assetManagement;

import sys.FileSystem;

/** This is a way of loading a type of "thing" from the files and storing it in a list for later use.
	For instance, you could have a registry of all characters in the game. Each entry has an "ID", used to
	identify it. For instance, "joe" might be the character Joe's ID. **/
abstract class Registry<T>
{
	/** Stores the currently loaded registry entries. **/
	var entries(default, null):Array<RegistryEntry> = [];

	public function new() {}

	/** Loads a specific entry of the given ID from the directory. **/
	public function load(directory:String, id:String):RegistryEntry
	{
		if (!FileSystem.exists(directory + "/" + id))
			return null;
		entries.push({directory: directory, id: id, data: loadData(directory + "/" + id)});
		return entries[entries.length - 1];
	}

	/** Create a new T from the data/files provided in the entry directory.
		@return A new instance of T generated from the data/files found in the directory at path.
	**/
	abstract function loadData(path:String):T;

	/** Loads all entries from the given directory. **/
	public function loadAll(directory:String)
	{
		if (!FileSystem.exists(directory) || !FileSystem.isDirectory(directory))
			return;
		for (id in FileSystem.readDirectory(directory))
			load(directory, id);
	}

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

	/** Removes and re-loads an entry of the given id. **/
	public function reload(id:String)
	{
		var directory:String = get(id).directory;
		remove(id);
		load(directory, id);
	}

	/** Clears all loaded entries and re-loads from the given directory. **/
	public function reloadAll(directory:String)
	{
		for (entry in entries)
		{
			if (entry.directory == directory)
				entries.remove(entry);
		}
		loadAll(directory);
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

	/** Returns all entries. **/
	public function getAll():Array<RegistryEntry>
	{
		return entries.copy();
	}
}

typedef RegistryEntry =
{
	directory:String,
	id:String,
	data:Dynamic
}
