package stage.elements;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TextElement extends FlxText implements IStageElement
{
	public function new(data:Dynamic)
	{
		if (data.width == null)
			data.width = FlxG.width;
		if (data.font == null)
			data.font = "Jann Script Bold";
		if (data.textAlign == null)
			data.textAlign = FlxTextAlign.LEFT;
		if (data.useOutline == null)
			data.useOutline = false;
		if (data.outlineColor == null)
			data.outlineColor = FlxColor.TRANSPARENT;
		super(0.0, 0.0, data.width, data.text);
		setFormat(data.font, data.size, FlxColor.WHITE, data.textAlign, data.useOutline ? FlxTextBorderStyle.OUTLINE_FAST : FlxTextBorderStyle.NONE,
			data.outlineColor);
	}

	public function onAddedToStage(stage:Stage) {}
}
