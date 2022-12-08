package;

import haxe.Json;
import sys.io.File;

typedef GraphicsSettings =
{
	antialiasing:Bool,
	flashingLights:Bool
}

typedef SoundSettings =
{
	missSoundVolume:Float
}

typedef GameplaySettings =
{
	downscroll:Bool,
	ghostTapping:Bool
}

/** Used to manage various game-wide settings. **/
class Settings
{
	public static var graphics:GraphicsSettings;
	public static var sound:SoundSettings;
	public static var gameplay:GameplaySettings;

	var initialized:Bool;

	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;

		// Assign default values
		graphics.antialiasing = true;
		graphics.flashingLights = true;

		sound.missSoundVolume = 0.5;

		gameplay.ghostTapping = true;
	}

	/** Converts the settings to a Dynamic which can be used for JSON. **/
	public static function toStringifiableJSON():Dynamic
	{
		var stringifiable:Dynamic = {};
		stringifiable.graphics = graphics;
		stringifiable.sound = sound;
		stringifiable.gameplay = gameplay;
		return stringifiable;
	}

	/** Loads the setings from parsed JSON. **/
	public static function loadParsedJSON(parsed:Dynamic)
	{
		graphics = parsed.graphics;
		sound = parsed.sound;
		gameplay = parsed.gameplay;
	}

	/** Saves the settings to a JSON which can be loaded when starting up the game. **/
	public static function saveToJSON()
	{
		var json:String = Json.stringify(toStringifiableJSON());
		File.write("settings.json").writeString(json);
	}
}
