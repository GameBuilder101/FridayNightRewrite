package;

import sys.FileSystem;

typedef Library =
{
	var name:String;
}

class AssetManager
{
	var libraries:Array<Library>;

	public function reloadLibraries()
	{
		libraries = new;
	}
}

class Registry<T>
{
	public var loaded(default, null):Array<T>;

	public function reload() {}
}
