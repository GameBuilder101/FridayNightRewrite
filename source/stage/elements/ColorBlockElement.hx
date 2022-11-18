package stage.elements;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class ColorBlockElement extends FlxSprite
{
	public function new(name:String, data:Dynamic)
	{
		super(0.0, 0.0);
		makeGraphic(data.width, data.height, FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]));
		if (data.alpha != null)
			alpha = data.alpha;
	}
}
