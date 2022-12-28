package music;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;

/** A conductor is used to play and keep track of the beat of music. **/
class Conductor extends FlxGroup
{
	/** The currently-playing music. **/
	public static var currentMusic(default, null):MusicData;

	/** The transitionPlay target. **/
	static var targetMusic(default, null):MusicData;

	/** The sound used to play the music. The timing of music is tied directly to the current time of the sound. **/
	static var sound:FlxSound = new FlxSound();

	/** The thing to be conducted. **/
	public var conducted:IConducted;

	var prevWholeBeat:Int = -1;

	public function new(conducted:IConducted)
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

	/** Plays the music.
		@param restart When true, will re-start the music even if it is already playing.
	**/
	public static function play(music:MusicData, looped:Bool, restart:Bool = true)
	{
		if (currentMusic == music && !restart)
			return;
		currentMusic = music;
		targetMusic = music;

		/* Set the FlxG music to the Conductor's sound. This ensures that the music will get
			paused when the game loses focus */
		FlxG.sound.music = sound;
		FlxTween.cancelTweensOf(sound);
		sound.loadEmbedded(music.sound, looped);
		sound.volume = music.volume;
		sound.play(true);
	}

	/** Fades out the currently-playing music and transitions to the provided.
		@param restart When true, will re-start the music even if it is already playing.
	**/
	public static function transitionPlay(music:MusicData, looped:Bool, duration:Float, restart:Bool = true)
	{
		if (targetMusic == music && !restart)
			return;
		targetMusic = music;

		FlxTween.cancelTweensOf(sound);
		// Fade the music out
		FlxTween.tween(sound, {volume: 0.0}, duration / 2.0, {
			onComplete: function(tween:FlxTween)
			{
				// Play the new music
				play(targetMusic, looped, restart);
				// Make sure the volume is still 0
				sound.volume = 0.0;
				// Fade in the new music
				FlxTween.tween(sound, {volume: targetMusic.volume}, duration / 2.0);
			}
		});
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
