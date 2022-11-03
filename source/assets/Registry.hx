package assets;

import sys.FileSystem;

/** This is a way of loading a type of "thing" from the files and storing it in a list for later use.
	For instance, you could have a registry of all characters in the game. **/
abstract class Registry<T>
{
	/** Stores the currently loaded registry entries. **/
	var entries:Array<Dynamic> = [];

	/** Loads a specific entry from the given path. **/
	public function load(path:String)
	{
		if (!FileSystem.exists(path) || !FileSystem.isDirectory(path))
			return;
		entries.push({path: path, data: loadData(path)});
	}

	/** Create a new T from the data/files provided in the entry directory.
		@return A new instance of T generated from the data/files found in the directory at path.
	**/
	abstract function loadData(path:String):T;

	/** Loads all entries from the given directory. **/
	public function loadFromDirectory(path:String)
	{
		var paths:Array<String> = FileSystem.readDirectory(path);
		for (path in paths)
			load(path);
	}

	/** Removes a loaded entry of the given path. **/
	public function remove(path:String)
	{
		for (entry in entries)
		{
			if (entry.path == path)
				entries.remove(entry);
		}
	}

	/** Clears all loaded entries from memory. **/
	public function clear()
	{
		entries = [];
	}

	/** Removes and re-loads an entry of the given path. **/
	public function reload(path:String)
	{
		remove(path);
		load(path);
	}

	/** Clears all loaded entries from memory and loads from the given directory. **/
	public function reloadFromDirectory(path:String)
	{
		clear();
		loadFromDirectory(path);
	}

	/** Returns the data of the entry with the given path. **/
	public function get(path:String):T
	{
		for (entry in entries)
		{
			if (entry.path == path)
				return cast entry.value;
		}
		return null;
	}
}
