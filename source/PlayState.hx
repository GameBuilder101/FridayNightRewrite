package;

import Album;
import SoundData;
import flixel.system.FlxSound;
import music.Conductor;
import music.MusicData;
import music.Song;
import stage.Stage;
import stage.elements.CharacterElement;

class PlayState extends ConductedState
{
	/** The current album. **/
	public var album(default, null):AlbumData;

	/** The current song. **/
	public var song(default, null):Song;

	/** For most songs, 0 is easy, 1 is normal, and 2 is hard. **/
	public var difficulty(default, null):Int;

	/** The week that was selected in the week select state. -1 if freeplay. **/
	public var weekIndex:Int = -1;

	/** Used to track progress through the current week (assuming there is one). **/
	var weekSongIndex:Int;

	public var score:Float;
	public var combo:Int;

	var voices:FlxSound = new FlxSound();

	/** All of the characters in the current stage. **/
	var characters:Map<String, Character> = new Map<String, Character>();

	/** 
		@param song When specified, this state will load that specific song. If you want the appropriate week song to load, set this null
	**/
	public function new(album:AlbumData, song:Song, difficulty:Int, weekIndex:Int = -1, weekSongIndex:Int = 0)
	{
		super();
		this.album = album;
		this.song = song;
		this.difficulty = difficulty;
		this.weekIndex = weekIndex;
		this.weekSongIndex = weekSongIndex;

		if (song == null && weekIndex >= 0) // If a specific song was not given, load the week song
			this.song = SongRegistry.getAsset(album.weeks[weekIndex].songIDs[weekSongIndex]);

		// Set up and initialize the instrumental/voices
		Conductor.play(MusicDataRegistry.getAsset(song.instrumentalID), false);
		Conductor.pause();
		SoundDataRegistry.getAsset(song.voicesID).playOn(voices);
		voices.pause();
	}

	function createStage():Stage
	{
		var stage:Stage = new Stage(StageDataRegistry.getAsset(song.stageID));
		// Get the singer characters from the stage
		var element:CharacterElement;
		for (character in stage.getElementsWithTag("character"))
		{
			if (!(character is CharacterElement))
				continue;
			element = cast(character, CharacterElement);
			characters.set(element.singerTag, element);
		}
		return stage;
	}

	public function getPlayer():Character
	{
		return characters[Character.PLAYER_TAG];
	}

	public function getOpponent():Character
	{
		return characters[Character.OPPONENT_TAG];
	}

	public function getGirlfriend():Character
	{
		return characters[Character.GIRLFRIEND_TAG];
	}

	public function startSong()
	{
		Conductor.resume();
		voices.resume();
	}
}
