package;

import Saver;

class Scores extends Saver
{
	public static var instance(default, null):Scores;
	static var initialized:Bool;

	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;
		instance = new Scores();
	}

	function getSaverID():String
	{
		return "scores";
	}

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():Map<String, Dynamic>
	{
		// Set the defaults for the scores
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		return data;
	}

	public static function getWeekHighScore(albumID:String, weekIndex:Int, difficulty:Int):HighScore
	{
		return instance.get("albumID: " + albumID + ", weekIndex: " + weekIndex + ", difficulty: " + difficulty);
	}

	public static function setWeekHighScore(albumID:String, weekIndex:Int, difficulty:Int, highScore:HighScore)
	{
		instance.set("albumID: " + albumID + ", weekIndex: " + weekIndex + ", difficulty: " + difficulty, highScore);
	}

	public static function getSongHighScore(songID:String, difficulty:Int):HighScore
	{
		return instance.get("songID: " + songID + ", difficulty: " + difficulty);
	}

	public static function setSongHighScore(songID:String, difficulty:Int, highScore:HighScore)
	{
		instance.set("songID: " + songID + ", difficulty: " + difficulty, highScore);
	}
}

typedef HighScore =
{
	score:Int,
	highestCombo:Int,
	fullCombo:Bool,
	ghostTapping:Bool
}
