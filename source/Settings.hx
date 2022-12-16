package;

import Saver;

/** Used to manage various game-wide settings. **/
class Settings extends Saver
{
	public static var instance(default, null):Settings;
	static var initialized:Bool;

	// Graphics settings
	public static inline final ANTIALIASING:String = "antialiasing";
	public static inline final SHADERS:String = "shaders";
	public static inline final FLASHING_LIGHTS:String = "flashing_lights";
	public static inline final CAMERA_BOP:String = "camera_bop";

	// Sound settings
	public static inline final MISS_SOUND_VOLUME:String = "miss_sound_volume";

	// Gameplay settings
	public static inline final DOWNSCROLL:String = "downscroll";
	public static inline final GHOST_TAPPING:String = "ghost_tapping";

	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;
		instance = new Settings();
	}

	function getSaverID():String
	{
		return "settings";
	}

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():Map<String, Dynamic>
	{
		// Set the defaults for the settings
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		data.set(ANTIALIASING, true);
		data.set(SHADERS, true);
		data.set(FLASHING_LIGHTS, true);
		data.set(CAMERA_BOP, true);
		data.set(MISS_SOUND_VOLUME, 1.0);
		data.set(DOWNSCROLL, false);
		data.set(GHOST_TAPPING, true);
		return data;
	}

	public static inline function getAntialiasing():Bool
	{
		return instance.get(ANTIALIASING);
	}

	public static inline function getShaders():Bool
	{
		return instance.get(SHADERS);
	}

	public static inline function getFlashingLights():Bool
	{
		return instance.get(FLASHING_LIGHTS);
	}

	public static inline function getCameraBop():Bool
	{
		return instance.get(CAMERA_BOP);
	}

	public static inline function getMissSoundVolume():Float
	{
		return instance.get(MISS_SOUND_VOLUME);
	}

	public static inline function getDownscroll():Bool
	{
		return instance.get(DOWNSCROLL);
	}

	public static inline function getGhostTapping():Bool
	{
		#if ALLOW_GHOST_TAPPING
		return instance.get(GHOST_TAPPING);
		#else
		return false;
		#end
	}
}
