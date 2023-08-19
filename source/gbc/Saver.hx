package gbc;

import flixel.FlxG;
import gbc.assets.FileManager;
import haxe.Json;

/** A saver is a container for data which can be saved and re-loaded on game start. **/
abstract class Saver<T:Dynamic>
{
	public var data(default, null):T;

	public function new()
	{
		data = getDefaultData();
		load();
	}

	/** Returns the method to use when saving. **/
	abstract function getSaverMethod():SaverMethod;

	abstract function getDefaultData():T;

	/** Saves the data to be re-loaded the next time the game is started.
		@param path Either the file path or the name of the field saved to FlxG.save.
	**/
	public function save(path:String = null)
	{
		if (path == null || path == "")
			path = "save";

		switch (getSaverMethod())
		{
			case FLX_SAVE:
				Reflect.setField(FlxG.save.data, path, data);
			case JSON:
				var json:String = Json.stringify(data, null, "    ");
				// Write to a JSON file
				FileManager.writeJson(path, json);
		}
	}

	/** Loads any saved data (if there is none, this does nothing).
		@param path Either the file path or the name of the field saved to FlxG.save.
	**/
	public function load(path:String = null)
	{
		if (path == null || path == "")
			path = "save";

		var data:Dynamic = getData(path);
		// If no existing saved data was found, then stop
		if (data == null)
			return;
		this.data = data;
	}

	/** Returns any saved data (if there is none, this returns null).
		@param path Either the file path or the name of the field saved to FlxG.save.
	**/
	function getData(path:String = null)
	{
		switch (getSaverMethod())
		{
			case FLX_SAVE:
				return Reflect.field(FlxG.save.data, path);
			default:
				return FileManager.getParsedJson(path);
		}
	}
}

enum SaverMethod
{
	FLX_SAVE;
	JSON;
}
