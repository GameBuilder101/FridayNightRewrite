package gbc.assets;

import flixel.graphics.FlxGraphic;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

/** Retrieves common asset/file types via sys.FileSystem and sys.io.File. **/
class FileManager
{
	/** 
		@param path The path including the file extension.
		@return The raw file contents at the given path.
	**/
	public static inline function getRaw(path:String):String
	{
		if (!FileSystem.exists(path))
			return null;
		return File.getContent(path);
	}

	/** 
		@param path The path including the file extension.
		@param contents The raw file contents at the given path.
	**/
	public static inline function writeRaw(path:String, contents:String)
	{
		var output:FileOutput = File.write(path);
		output.writeString(contents);
		output.close();
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getText(path:String):String
	{
		return getRaw(path + ".txt");
	}

	/** @param path The path excluding the file extension. **/
	public static inline function writeText(path:String, contents:String)
	{
		writeRaw(path + ".txt", contents);
	}

	/** @param path The path excluding the file extension. **/
	public static function getParsedJson(path:String):Dynamic
	{
		var json:String = getRaw(path + ".json");
		if (json == null)
			return null;
		return Json.parse(json);
	}

	/** @param path The path excluding the file extension. **/
	public static inline function writeJson(path:String, contents:String)
	{
		writeRaw(path + ".json", contents);
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getXML(path:String):String
	{
		return getRaw(path + ".xml");
	}

	/** @param path The path excluding the file extension. **/
	public static inline function writeXML(path:String, contents:String)
	{
		writeRaw(path + ".xml", contents);
	}

	/** @param path The path excluding the file extension. **/
	public static inline function getHScript(path:String):String
	{
		return getRaw(path + ".hxs");
	}

	/** @param path The path excluding the file extension. **/
	public static inline function writeHScript(path:String, contents:String)
	{
		writeRaw(path + ".hxs", contents);
	}

	/** @param path The path excluding the file extension. **/
	public static function getGraphic(path:String):FlxGraphic
	{
		var source:BitmapData = BitmapData.fromFile(path + ".png");
		if (source == null)
			return null;
		var graphic:FlxGraphic = FlxGraphic.fromBitmapData(source, false, path);
		graphic.persist = true;
		return graphic;
	}

	/** @param path The path excluding the file extension. **/
	public static function getSound(path:String):Sound
	{
		if (FileSystem.exists(path + ".ogg"))
			return Sound.fromFile(path + ".ogg");
		else
			return null;
	}
}
