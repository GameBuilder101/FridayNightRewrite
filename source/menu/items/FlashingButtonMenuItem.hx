package menu.items;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import menu.MenuItem;

/** A button menu item which flashes the background when selected. **/
class FlashingButtonMenuItem extends ButtonMenuItem
{
	var flashingTime:Float = -1.0;

	var background:FlxSprite;
	var origBackgroundColor:FlxColor;

	public function new(functions:MenuItemFunctions, ?labelText:String, ?iconID:String, useCancel:Bool = false)
	{
		super(functions, labelText, iconID);
		// Get the background to animate
		if (menu.stage != null)
		{
			var backgrounds:Array<FlxSprite> = menu.stage.getElementsWithTag("menu_background");
			if (backgrounds != null)
				background = backgrounds[0];
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (flashingTime >= 0.0) // If playing flash animation
		{
			flashingTime += elapsed;
			// Make the label and background flash
			if (Settings.getFlashingLights())
				label.color = FlxMath.fastSin(flashingTime * 24.0) <= 0.0 ? menu.normalItemColor : menu.selectedItemColor;
			if (background != null)
				background.color = label.color;
			leftmostArrow.color = label.color;
			rightmostArrow.color = label.color;
		}
	}

	override function onDeselected()
	{
		super.onDeselected();
		stopFlashing();
	}

	override function onInteracted(value:Dynamic)
	{
		super.onInteracted(value);
		playFlashing();
	}

	public function playFlashing()
	{
		if (flashingTime >= 0.0) // Don't play if we are already
			return;
		flashingTime = 0.0;
		if (background != null)
			origBackgroundColor = background.color;
	}

	public function stopFlashing()
	{
		if (flashingTime < 0.0)
			return;
		flashingTime = -1.0;
		background.color = origBackgroundColor;
	}
}
