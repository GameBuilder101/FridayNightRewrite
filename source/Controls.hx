package;

import flixel.FlxG;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;

/** Used to access and manage game-specific controls. **/
class Controls
{
	public static var volumeUp:FlxActionInputDigital;
	public static var volumeDown:FlxActionInputDigital;
	public static var mute:FlxActionInputDigital;

	public static var uiLeft:FlxActionInputDigital;
	public static var uiDown:FlxActionInputDigital;
	public static var uiUp:FlxActionInputDigital;
	public static var uiRight:FlxActionInputDigital;
	public static var accept:FlxActionInputDigital;
	public static var cancel:FlxActionInputDigital;

	public static var noteLeft:FlxActionInputDigital;
	public static var noteDown:FlxActionInputDigital;
	public static var noteUp:FlxActionInputDigital;
	public static var noteRight:FlxActionInputDigital;

	static var initialized:Bool;
	static var input:FlxActionManager = new FlxActionManager();

	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;
		FlxG.inputs.add(input);
	}
}
