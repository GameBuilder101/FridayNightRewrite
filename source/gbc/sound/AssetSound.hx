package gbc.sound;

import flixel.FlxG;
import flixel.sound.FlxSound;
import openfl.media.Sound;

/** An asset-sound can have volume and variant properties defined
	in a JSON file and loaded at runtime. **/
class AssetSound
{
	public var variants:Array<AssetSoundVariant>;

	public function new(variants:Array<AssetSoundVariant> = null, variant:AssetSoundVariant = null)
	{
		if (variants == null)
			this.variants = [variant];
		else
			this.variants = variants;
	}

	/** Returns a random sound variant. **/
	public function getVariant():AssetSoundVariant
	{
		return variants[Math.floor(Math.random() * variants.length)];
	}

	/** Plays a random sound variant using FlxG.sound. **/
	public function play()
	{
		var variant:AssetSoundVariant = getVariant();
		FlxG.sound.play(variant.sound, variant.volume);
	}

	/** Plays a random sound variant using the provided FlxSound. **/
	public function playOn(sound:FlxSound)
	{
		var variant:AssetSoundVariant = getVariant();
		sound.loadEmbedded(variant.sound);
		sound.volume = variant.volume;
		sound.play(true);
	}
}

typedef AssetSoundVariant =
{
	sound:Sound,
	volume:Float
}
