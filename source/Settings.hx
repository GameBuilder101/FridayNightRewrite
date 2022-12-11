package;

import Saver;

typedef GraphicsSettings =
{
	antialiasing:Bool,
	shaders:Bool,
	flashingLights:Bool,
	cameraBop:Bool
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
class Settings extends Saver
{
	public static var graphics:GraphicsSettings = {
		antialiasing: true,
		shaders: true,
		flashingLights: true,
		cameraBop: true
	};
	public static var sound:SoundSettings = {missSoundVolume: 1.0};
	public static var gameplay:GameplaySettings = {downscroll: false, ghostTapping: true};

	function getSaverID():String
	{
		return "settings";
	}

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getInitialData():Map<String, Dynamic>
	{
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		data.set("graphics", graphics);
		data.set("sound", sound);
		data.set("gameplay", gameplay);
		return data;
	}
}
