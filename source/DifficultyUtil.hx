package;

import flixel.util.FlxColor;

/** Used to define names/colors for difficulties. **/
class DifficultyUtil
{
	public static final BUILTIN:Array<Difficulty> = [
		{name: "Easy", color: FlxColor.fromRGB(22, 240, 83)},
		{name: "Normal", color: FlxColor.fromRGB(253, 232, 113)},
		{name: "Hard", color: FlxColor.fromRGB(247, 51, 154)}
	];

	/** The difficulty selected by default. **/
	public static final DEFAULT_SELECTED:Int = 1;

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
