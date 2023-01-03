package stage.elements;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class BoxSpriteElement extends FlxSprite implements IStageElement
{
	public function new(data:Dynamic)
	{
		super(0.0, 0.0);
		if (data.color == null)
			data.color = [255, 255, 255];
		makeGraphic(data.width, data.height, FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]));
		if (data.alpha != null)
			alpha *= data.alpha;
		if (data.blend != null)
			blend = data.blend;
	}

	public function onAddedToStage(stage:Stage) {}
}
