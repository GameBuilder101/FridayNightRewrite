package stage.elements;

import flixel.util.FlxColor;
import music.Conducted;

class GeneralSpriteElement extends AssetSprite implements StageElement implements Conducted
{
	var beatAnimName:String;
	var beatAnimFrequency:Float;

	public function new(name:String, data:Dynamic)
	{
		super(0.0, 0.0, null, data.id);
		if (data.recolor != null)
			color = FlxColor.fromRGB(data.recolor[0], data.recolor[1], data.recolor[2]);
		if (data.alpha != null)
			alpha = data.alpha;
		beatAnimName = data.beatAnimName;
		beatAnimFrequency = data.beatAnimFrequency;
	}

	public function onAddedToStage(stage:Stage) {}

	public function updateMusic(time:Float, bpm:Float, beat:Float) {}

	public function onWholeBeat(beat:Int)
	{
		if (beatAnimName != null && beat % beatAnimFrequency == 0.0)
			animation.play(beatAnimName, true);
	}
}
