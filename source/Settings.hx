package;

import Character;
import Saver;

/** Used to manage various game-wide settings. **/
class Settings extends Saver
{
	public static var instance(default, null):Settings;
	static var initialized:Bool;

	// Graphics settings
	public static inline final ANTIALIASING:String = "antialiasing";
	public static inline final SHADERS:String = "shaders";
	public static inline final FLASHING_LIGHTS:String = "flashingLights";
	public static inline final CAMERA_BOP:String = "cameraBop";

	// Sound settings
	public static inline final MISS_SOUND_VOLUME:String = "missSoundVolume";

	// Gameplay settings
	public static inline final DOWNSCROLL:String = "downscroll";
	public static inline final GHOST_TAPPING:String = "ghostTapping";

	// Other
	public static inline final PLAYER_CHARACTER:String = "playerCharacter";
	public static inline final GIRLFRIEND_CHARACTER:String = "girlfriendCharacter";

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
		data.set(PLAYER_CHARACTER, "bf");
		data.set(GIRLFRIEND_CHARACTER, "gf");
		return data;
	}

	// The following get/set functions are not inline since (I'm pretty sure) that would make them inaccessible to runtime scripts

	public static function getAntialiasing():Bool
	{
		return instance.get(ANTIALIASING);
	}

	public static function setAntialiasing(value:Bool)
	{
		return instance.set(ANTIALIASING, value);
	}

	public static function getShaders():Bool
	{
		return instance.get(SHADERS);
	}

	public static function setShaders(value:Bool)
	{
		return instance.set(SHADERS, value);
	}

	public static function getFlashingLights():Bool
	{
		return instance.get(FLASHING_LIGHTS);
	}

	public static function setFlashingLights(value:Bool)
	{
		return instance.set(FLASHING_LIGHTS, value);
	}

	public static function getCameraBop():Bool
	{
		return instance.get(CAMERA_BOP);
	}

	public static function setCameraBop(value:Bool)
	{
		return instance.set(CAMERA_BOP, value);
	}

	public static function getMissSoundVolume():Float
	{
		return instance.get(MISS_SOUND_VOLUME);
	}

	public static function setMissSoundVolume(value:Float)
	{
		return instance.set(MISS_SOUND_VOLUME, value);
	}

	public static function getDownscroll():Bool
	{
		return instance.get(DOWNSCROLL);
	}

	public static function setDownscroll(value:Bool)
	{
		return instance.set(DOWNSCROLL, value);
	}

	public static function getGhostTapping():Bool
	{
		#if ALLOW_GHOST_TAPPING
		return instance.get(GHOST_TAPPING);
		#else
		return false;
		#end
	}

	public static function setGhostTapping(value:Bool)
	{
		return instance.set(GHOST_TAPPING, value);
	}

	public static function getPlayerCharacter():CharacterData
	{
		var character:CharacterData = CharacterDataRegistry.getAsset(instance.get(PLAYER_CHARACTER));
		// In case the mod containing the character was deleted, just return a default
		if (character == null)
			return CharacterDataRegistry.getAsset("bf");
		return character;
	}

	public static function setPlayerCharacter(value:String)
	{
		return instance.set(PLAYER_CHARACTER, value);
	}

	public static function getGirlfriendCharacter():CharacterData
	{
		var character:CharacterData = CharacterDataRegistry.getAsset(instance.get(GIRLFRIEND_CHARACTER));
		// In case the mod containing the character was deleted, just return a default
		if (character == null)
			return CharacterDataRegistry.getAsset("gf");
		return character;
	}

	public static function setGirlfriendCharacter(value:String)
	{
		return instance.set(GIRLFRIEND_CHARACTER, value);
	}
}
