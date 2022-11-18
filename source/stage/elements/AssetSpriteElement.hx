package stage.elements;

import flixel.util.FlxColor;

class AssetSpriteElement extends AssetSprite
{
	public function new(name:String, data:Dynamic)
	{
		super(0.0, 0.0, data.id);
		if (data.recolor != null)
			color = FlxColor.fromRGB(data.recolor[0], data.recolor[1], data.recolor[2]);
		if (data.alpha != null)
			alpha = data.alpha;
	}
}
