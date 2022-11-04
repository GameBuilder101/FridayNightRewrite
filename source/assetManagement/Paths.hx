package assetManagement;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;

/** Simplifies retrieving certain files. */
class Paths
{
	/** @param path The path excluding the file extension. */
	public static inline function getParsedJson(path:String):Dynamic
	{
		path += ".json";
		if (!FileSystem.exists(path))
			return null;
		return Json.parse(File.getContent(path));
	}
}
