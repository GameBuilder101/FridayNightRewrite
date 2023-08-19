package gbc.sound;

import flixel.FlxG;
import openfl.media.Sound;

/** Asset-music can have volume properties defined in a JSON file
	and loaded at runtime. **/
class AssetMusic
{
	public var sound:Sound;
	public var volume:Float;

	public function new(sound:Sound, volume:Float = 1.0)
	{
		this.sound = sound;
		this.volume = volume;
	}

	/** Plays the music using FlxG.music. **/
	public function play(looped:Bool = true)
	{
		FlxG.sound.playMusic(sound, volume, looped);
	}
}
