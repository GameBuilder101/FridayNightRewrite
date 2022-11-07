package;

import assetManagement.LibraryManager;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		LibraryManager.reloadLibraries();
		addChild(new FlxGame(0, 0, AlbumSelectState, 1.0, 60, 60, true, false));
	}
}
