package stage.elements;

import flixel.util.FlxColor;
import music.Conducted;

class GeneralSpriteElement extends AssetSprite implements StageElement implements Conducted
{
	var beatAnimFrequency:Float;
	var beatAnimName:String;

	public function new(name:String, data:Dynamic)
	{
		super(0.0, 0.0, null, data.id);
		if (data.flipX != null && data.flipX)
			flipX = !flipX;
		if (data.flipY != null && data.flipY)
			flipY = !flipY;
		if (data.color != null)
			color *= FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);
		if (data.alpha != null)
			alpha *= data.alpha;
		beatAnimFrequency = data.beatAnimFrequency;
		beatAnimName = data.beatAnimName;
	}

	public function onAddedToStage(stage:Stage) {}

	public function updateMusic(time:Float, bpm:Float, beat:Float) {}

	public function onWholeBeat(beat:Int)
	{
		if (beatAnimName != null && beat % beatAnimFrequency == 0.0)
			animation.play(beatAnimName, true);
	}
}
