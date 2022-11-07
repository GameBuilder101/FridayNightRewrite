package assetManagement;

import haxe.Json;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;

/** Retrieves common asset/file types via sys.FileSystem and sys.io.File. Note: This does not interact directly with mods in any way. **/
class FileManager
{
	/** 
		@param path The path INCLUDING the file extension.
		@return The raw file contents at the given path.
	**/
	public static inline function getRaw(path:String):String
	{
		if (!FileSystem.exists(path))
			return null;
		return File.getContent(path);
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getText(path:String):String
	{
		return getRaw(path + ".txt");
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getParsedJson(path:String):Dynamic
	{
		var json:String = getRaw(path + ".json");
		if (json == null)
			return null;
		return Json.parse(json);
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getXML(path:String):String
	{
		return getRaw(path + ".xml");
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getBitmapData(path:String):BitmapData
	{
		return BitmapData.fromFile(path + ".png");
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getSound(path:String):Sound
	{
		if (FileSystem.exists(path + ".mp3"))
			return Sound.fromFile(path + ".mp3");
		return Sound.fromFile(path + ".ogg");
	}
}
