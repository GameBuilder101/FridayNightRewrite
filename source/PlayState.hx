package;

import Week;
import music.Song;
import stage.Stage;

class PlayState extends ConductedState
{
	/** The current song. **/
	public var song(default, null):SongData;

	/** For most songs, 0 is easy, 1 is normal, and 2 is hard. **/
	public var difficulty(default, null):Int;

	/** The week that was selected in the week select state. **/
	public var week(default, null):WeekData;

	/** Used to track progress through the current week (assuming there is one). **/
	var weekSongIndex:Int;

	public var score:Float;
	public var combo:Int;

	/** 
		@param song When specified, this state will load that specific song. If you want the appropriate week song to load, set this null
	**/
	public function new(song:SongData, difficulty:Int, week:WeekData = null, weekSongIndex:Int = 0)
	{
		super();
		this.song = song;
		this.difficulty = difficulty;
		this.week = week;
		this.weekSongIndex = weekSongIndex;
		if (song == null && week != null) // If a specific song was not given, load the week song
			song = SongDataRegistry.getAsset(week.songIDs[weekSongIndex]);
	}

	function createStage():Stage
	{
		return new Stage(StageDataRegistry.getAsset(song.stageID));
	}
}
