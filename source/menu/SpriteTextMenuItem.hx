package menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import menu.MenuItem;
import music.ConductedState;

/** A type of menu item skin which uses sprite-text labels. **/
class SpriteTextMenuItem extends MenuItem
{
	public var label(default, null):SpriteText;
	public var icon(default, null):AssetSprite;

	public var leftButtonArrow(default, null):AssetSprite;
	public var rightButtonArrow(default, null):AssetSprite;

	var prevIsInteractTarget:Bool;

	/** Used to prevent the select sound from playing if this is the initially-selected menu item. **/
	var tempDisableSelectSound:Bool;

	var flashing:Bool;
	var flashingTime:Float;

	var background:FlxSprite;
	var origBackgroundColor:FlxColor;

	public function new(menu:Menu, index:Int, data:MenuItemData)
	{
		super(menu, index, data);
		tempDisableSelectSound = true;

		label = new SpriteText(x, y, data.label, menu.fontSize, menu.menuType == RADIAL ? LEFT : CENTER, true);
		add(label);

		if (data.iconID != null && data.iconID != "")
		{
			icon = new AssetSprite(x, y + label.height / 2.0, data.iconID);
			if (icon.animation.exists("menu_idle"))
				icon.animation.play("menu_idle");
			icon.scale.set(label.height * 1.5, label.height * 1.5);
			icon.updateHitbox();
			icon.offset.set(icon.width / 2.0, icon.height / 2.0);
			icon.x -= icon.offset.x;
			add(icon);
		}

		// Create item-type-specific graphic elements
		switch (data.type)
		{
			case LABEL:
			case BUTTON:
				leftButtonArrow = new AssetSprite(x - 16.0, y, "menus/_shared/arrow");
				leftButtonArrow.updateHitbox();
				leftButtonArrow.offset.set(leftButtonArrow.width, 0.0);
				leftButtonArrow.visible = false;
				add(leftButtonArrow);
				rightButtonArrow = new AssetSprite(x + label.width + 16.0, y, "menus/_shared/arrow");
				rightButtonArrow.updateHitbox();
				rightButtonArrow.flipX = true;
				rightButtonArrow.visible = false;
				add(rightButtonArrow);
			case TOGGLE:
			case SELECTION:
			case CONTROL_SCHEME:
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isInteractTarget:Bool = getIsInteractTarget();

		if (flashing)
		{
			// Make the label and background flash
			var useFlashColor:Bool = FlxMath.fastSin(flashingTime * 0.1) <= 0.5;
			label.color = useFlashColor ? menu.normalItemColor : menu.selectedItemColor;
			if (background != null)
				background.color = useFlashColor ? menu.selectedItemColor : origBackgroundColor;
		}
		else if (!interactable)
			label.color = menu.disabledItemColor;
		else if (isInteractTarget)
			label.color = menu.selectedItemColor;
		else
			label.color = menu.normalItemColor;

		if (!prevIsInteractTarget && isInteractTarget && menu.waveSelectedItem)
			label.playWaveAnimation(4.0, 0.25, 2.0);
		else if (!isInteractTarget || !menu.waveSelectedItem)
			label.resetWaveAnimation();

		if (!prevIsInteractTarget && isInteractTarget && menu.selectSound != null && !tempDisableSelectSound)
			menu.selectSound.play();
		tempDisableSelectSound = false;

		// Update item-type-specific things
		switch (data.type)
		{
			case LABEL:
			case BUTTON:
				// Make the label have arrow icons if it is a button and selected
				leftButtonArrow.visible = isInteractTarget;
				leftButtonArrow.color = label.color;
				rightButtonArrow.visible = isInteractTarget;
				rightButtonArrow.color = label.color;

				if (isInteractTarget && FlxG.keys.justPressed.ENTER)
					playFlashingAnimation();
			case TOGGLE:
			case SELECTION:
			case CONTROL_SCHEME:
		}

		prevIsInteractTarget = isInteractTarget;
	}

	function playFlashingAnimation()
	{
		if (flashing)
			return;
		flashing = true;
		flashingTime = 0.0;

		// Get the background to animate
		if (FlxG.state is ConductedState)
		{
			var backgrounds:Array<FlxSprite> = cast(FlxG.state, ConductedState).stage.getElementsWithTag("menu_background");
			if (backgrounds != null)
			{
				background = backgrounds[0];
				origBackgroundColor = background.color;
			}
		}
	}

	function stopFlashingAnimation()
	{
		if (!flashing)
			return;
		flashing = false;
		background.color = origBackgroundColor;
	}
}
