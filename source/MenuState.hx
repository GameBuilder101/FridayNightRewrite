package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import music.ConductedState;
import music.MusicData;

class MenuState extends ConductedState
{
	override public function create()
	{
		super.create();
		conductor.play(MusicRegistry.getAsset("menus/_shared/funky_menu_theme"), true);

		add(new FlxSprite(0.0, 0.0).makeGraphic(1280, 720, FlxColor.WHITE));
		add(new SpriteText(256.0, 256.0, "Hello world", 1.0, false));
	}
}
