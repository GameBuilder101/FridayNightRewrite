package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Lib.reloadLibraries();
		addChild(new FlxGame(0, 0, PlayState, 1.0, 60, 60, true, false));
	}
}
