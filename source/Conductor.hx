package;

import MusicData;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

/** A conductor is used to play and keep track of the beat of music. **/
class Conductor extends FlxGroup
{
	/** The currently-playing music. **/
	public var music(default, null):MusicData;

	/** The sound used to play the current music. The timing of music is tied directly to the current time of the sound. **/
	var sound:FlxSound = new FlxSound();

	public function new(maxSize:Int = 0)
	{
		super(maxSize);
		add(sound);
	}

	public function play(music:MusicData, looped:Bool)
	{
		this.music = music;
		sound.loadEmbedded(music.sound, looped);
		sound.play(true);
	}

	public function stop()
	{
		music = null;
		sound.stop();
	}

	public inline function pause()
	{
		sound.pause();
	}

	public inline function resume()
	{
		sound.resume();
	}

	/** Sets the current playback time of the music. **/
	public inline function setTime(time:Float)
	{
		sound.time = time;
	}

	/** Gets the current playback time of the music. **/
	public inline function getTime():Float
	{
		return sound.time;
	}

	/** Calculates the current BPM. **/
	public function getCurrentBPM():Float
	{
		return music.getBPMAt(getTime());
	}

	/** Calculates the current beat. **/
	public function getCurrentBeat():Int
	{
		return music.getBeatAt(getTime());
	}
}
