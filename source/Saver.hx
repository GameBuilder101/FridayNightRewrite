package;

import assetManagement.FileManager;
import flixel.FlxG;
import haxe.Json;
import sys.io.File;

/** A saver is a container for related data which can be saved and re-loaded on game start. **/
abstract class Saver
{
	var data:Map<String, Dynamic>;

	public function new()
	{
		data = getInitialData();
	}

	/** The save ID is either used for the field name when using FlxG.save or the file name when using JSON. **/
	abstract function getSaverID():String;

	/** Returns the method to use when saving. **/
	abstract function getSaverMethod():SaverMethod;

	abstract function getInitialData():Map<String, Dynamic>;

	/** Saves the data to be re-loaded the next time the game is started. **/
	public function save()
	{
		// Convert the data into a savable array
		var savable:Array<Dynamic> = new Array<Dynamic>();
		for (key in data.keys())
		{
			savable.push({key: key, value: data[key]});
		}

		switch (getSaverMethod())
		{
			case FLX_SAVE:
				Reflect.setField(FlxG.save.data, getSaverID(), savable);
			case JSON:
				var json:String = Json.stringify(savable);
				// Write to a JSON file
				File.write(getSaverID() + ".json").writeString(json);
		}
	}

	/** Loads any saved data (if there is none, this does nothing). **/
	public function load()
	{
		var savable:Array<Dynamic>;
		switch (getSaverMethod())
		{
			case FLX_SAVE:
				savable = Reflect.field(FlxG.save.data, getSaverID());
			case JSON:
				savable = FileManager.getParsedJson(getSaverID() + ".json");
		}

		// If no existing saved data was found, then stop
		if (savable == null)
		{
			trace("No saved data found for Saver '" + getSaverID() + "'");
			return;
		}
		trace("Saved data found for Saver '" + getSaverID() + "': " + savable);

		for (item in savable)
			data.set(item.key, item.value);
	}
}

/** FLX_SAVE is better if you want the data to be hidden and more difficult to edit. JSON is better for more easily-modified data. **/
enum SaverMethod
{
	FLX_SAVE;
	JSON;
}
