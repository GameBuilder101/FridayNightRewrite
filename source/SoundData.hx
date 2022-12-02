package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.FlxG;
import flixel.system.FlxSound;
import openfl.media.Sound;

/** Sound data is used to store sounds with variations. **/
class SoundData
{
	var variants(default, null):Array<SoundVariant> = new Array<SoundVariant>();

	public function new(variants:Array<SoundVariant>)
	{
		this.variants = variants;
	}

	/** Returns a random variant. **/
	public function getRandom():SoundVariant
	{
		return variants[FlxG.random.int(0, variants.length - 1)];
	}

	/** Plays a random sound variant using FlxG.sound. **/
	public function play()
	{
		var variant:SoundVariant = getRandom();
		FlxG.sound.play(variant.sound, variant.volume);
	}

	/** Plays a random sound variant using the provided FlxSound. **/
	public function playOn(sound:FlxSound)
	{
		var variant:SoundVariant = getRandom();
		sound.loadEmbedded(variant.sound);
		sound.volume = variant.volume;
		sound.play(true);
	}
}

typedef SoundVariant =
{
	sound:Sound,
	volume:Float
}

/** Use this to access/load sound data. **/
class SoundRegistry extends Registry<SoundData>
{
	static var cache:SoundRegistry = new SoundRegistry();

	function loadData(directory:String, id:String):SoundData
	{
		var path:String = Registry.getFullPath(directory, id);
		var parsed:Dynamic = FileManager.getParsedJson(path);
		var sound:Sound;

		if (parsed == null || parsed.variants == null) // If JSON data for the sound variants were not supplied, look for a standalone sound file instead
		{
			sound = FileManager.getSound(path);
			if (sound == null) // If a sound file was also not found, then this sound doesn't exist
				return null;
			var volume:Float = 1.0;
			if (parsed != null)
				volume = parsed.volume;
			// Since no JSON data was given, we just have to assume the volume is 1
			return new SoundData([{sound: sound, volume: volume}]);
		}

		// Construct the variants array from the parsed data's variants
		var variants:Array<SoundVariant> = new Array<SoundVariant>();
		for (variant in cast(parsed.variants, Array<Dynamic>))
		{
			sound = FileManager.getSound(Registry.getFullPath(directory, variant.soundID));
			if (sound == null) // If this variant's sound file couldn't be found, don't add it
				continue;

			// Fill in default variant values if the data is missing
			if (variant.volume == null)
				variant.volume = 1.0;

			variants.push({sound: sound, volume: variant.volume});
		}

		if (variants.length <= 0) // Don't return sound data if it has no sounds to be played
			return null;
		return new SoundData(variants);
	}

	public static function getAsset(id:String):SoundData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Resets the cache. **/
	public static function reset()
	{
		cache.clear();
	}
}
