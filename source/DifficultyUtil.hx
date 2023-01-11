package;

import flixel.util.FlxColor;

/** Used to define names/colors for difficulties. **/
class DifficultyUtil
{
	public static final BUILTIN:Array<Difficulty> = [
		{name: "Easy", color: FlxColor.fromRGB(0, 0, 0)},
		{name: "Normal", color: FlxColor.fromRGB(0, 0, 0)},
		{name: "Hard", color: FlxColor.fromRGB(0, 0, 0)}
	];

	/** The max difficulty. **/
	public static inline function getMax():Int
	{
		return BUILTIN.length;
	}
}

typedef Difficulty =
{
	name:String,
	color:FlxColor
}
