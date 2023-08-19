package gbc.assets;

using StringTools;

abstract class Registry<T>
{
	var cache:Map<String, T> = new Map<String, T>();

	public var source:String = "";

	/** @param source Any items loaded by this registry will have source added in front of the path. **/
	public function new(source:String)
	{
		if (!source.endsWith("/") || !source.endsWith("\\"))
			source += "/";
		this.source = source;
	}

	/** Convert from file data into an instance of T. **/
	public abstract function parse(data:Dynamic):T;

	/** Convert from an instance of T into file data.
		@param path The output location (not relative to the executable directory!)
	**/
	public abstract function export(item:T, path:String):Void;

	/** Loads a T from a path. Return null if something goes wrong.
		@param path The path (made up of the source and item id).
	**/
	abstract function load(path:String):T;

	public function get(id:String):T
	{
		if (cache.exists(id))
			return cache[id];
		var item:T = load(source + id);
		if (item == null)
			return null;
		cache.set(id, item);
		return item;
	}

	/** Gets the ID of a loaded item. Returns null if one cannot be found. **/
	public function getID(item:T):String
	{
		for (keyValue in cache.keyValueIterator())
		{
			if (keyValue.value == item)
				return keyValue.key;
		}
		return null;
	}

	/** Returns the executable-relative path to an item including the source. **/
	public function getFullPath(item:T):String
	{
		return source + getID(item);
	}

	public function clearCache()
	{
		cache.clear();
	}
}
