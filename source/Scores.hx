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
}
