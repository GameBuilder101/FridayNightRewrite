package;

import AssetSprite;
import music.ConductedState;
import music.MusicData;

class MenuState extends ConductedState
{
	var boyend:AssetSprite;
	var obunga:SpriteText;

	override public function create()
	{
		super.create();
		// conductor.play(MusicRegistry.getAsset("menus/_shared/funky_menu_theme"), true);
		// boyend = new AssetSprite(400.0, 400.0, "characters/bf/sprite_normal");
		// add(boyend);

		obunga = new SpriteText(100.0, 100.0, "i like cheese!!!!...", 1.0, true);
		add(obunga);
	}

	override function onBeat(beat:Int)
	{
		super.onBeat(beat);
		// boyend.animation.play("idle", true);
	}
}
