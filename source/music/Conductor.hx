package music;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

/** A conductor is used to play and keep track of the beat of music. **/
class Conductor extends FlxGroup
{
	/** The currently-playing music. **/
	public static var currentMusic(default, null):MusicData;

	/** The sound used to play the music. The timing of music is tied directly to the current time of the sound. **/
	static var sound:FlxSound = new FlxSound();

	/** The thing to be conducted. **/
	public var conducted:Conducted;

	var prevWholeBeat:Int = -1;

	public function new(conducted:Conducted)
	{
		super();
		this.conducted = conducted;
		sound.persist = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (currentMusic == null || conducted == null)
			return;
		var beat:Float = getCurrentBeat();

		if (prevWholeBeat != Std.int(beat))
		{
			prevWholeBeat = Std.int(beat);
			conducted.onWholeBeat(prevWholeBeat);
		}

		conducted.updateMusic(getTime(), getCurrentBPM(), beat);
	}

	public static function play(music:MusicData, looped:Bool)
	{
		currentMusic = music;

		/* Set the FlxG music to the Conductor's sound. This ensures that the music will get
			paused when the game loses focus */
		FlxG.sound.music = sound;
		sound.loadEmbedded(music.sound, looped);
		sound.volume = music.volume;
		sound.play(true);
	}

	public static function stop()
	{
		currentMusic = null;
		sound.stop();
	}

	public static inline function pause()
	{
		sound.pause();
	}

	public static inline function resume()
	{
		sound.resume();
	}

	/** Sets the current playback time of the music. **/
	public static inline function setTime(time:Float)
	{
		sound.time = time;
	}

	/** Gets the current playback time of the music. **/
	public static inline function getTime():Float
	{
		return sound.time;
	}

	/** Calculates the current BPM. **/
	public static function getCurrentBPM():Float
	{
		if (currentMusic == null)
			return 0.0;
		return currentMusic.getBPMAt(getTime());
	}

	/** Calculates the current beat. **/
	public static function getCurrentBeat():Float
	{
		if (currentMusic == null)
			return -1.0;
		return currentMusic.getBeatAt(getTime());
	}

	public static function fadeIn(duration:Float)
	{
		sound.fadeIn(duration, 0.0, currentMusic.volume);
	}

	public static function fadeOut(duration:Float)
	{
		sound.fadeOut(duration);
	}
}
