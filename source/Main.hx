package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var assetManager(default, null):AssetManager;

	public function new()
	{
		super();
		assetManager = new AssetManager();
		addChild(new FlxGame(0, 0, PlayState, 1.0, 60, 60, true, true));
	}
}
