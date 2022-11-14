package;

import MusicData;

class MenuState extends ConductedState
{
	var boyend:AssetSprite;

	override public function create()
	{
		super.create();
		conductor.play(MusicRegistry.getAsset("menus/_shared/funky_menu_theme"), true);
		boyend = new AssetSprite(400, 400, "characters/bf/sprite_normal");
		add(boyend);
	}

	override function onBeat(beat:Int)
	{
		super.onBeat(beat);
		if (beat % 2.0 == 0.0)
			boyend.animation.play("idle", true);
	}
}
