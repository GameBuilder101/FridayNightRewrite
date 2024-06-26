package;

import assetManagement.LibraryManager;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		LibraryManager.reloadLibraries(); // Load libraries before starting
		LibraryManager.preload();
		addChild(new FlxGame(0, 0, TitleScreenState, 60, 60, true, false));
	}
}
