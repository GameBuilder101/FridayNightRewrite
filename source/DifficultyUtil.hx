package;

import flixel.util.FlxColor;

/** Used to define names/colors for difficulties. **/
class DifficultyUtil
{
	public static final BUILTIN:Array<Difficulty> = [
		{name: "Easy", color: FlxColor.fromRGB(219, 33, 86)},
		{name: "Normal", color: FlxColor.fromRGB(253, 232, 113)},
		{name: "Hard", color: FlxColor.fromRGB(247, 51, 154)}
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
