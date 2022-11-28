package menu;

import flixel.util.FlxColor;
import menu.MenuItem;

/** A type of menu item skin which uses sprite-text labels. **/
class SpriteTextMenuItem extends MenuItem
{
	public var label(default, null):SpriteText;
	public var icon(default, null):AssetSprite;

	var prevIsInteractTarget:Bool;

	/** Used to prevent the select sound from playing if this is the initially-selected menu item. **/
	var tempDisableSelectSound:Bool;

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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isInteractTarget:Bool = getIsInteractTarget();

		if (!interactable)
			label.color = menu.disabledItemColor;
		else if (isInteractTarget)
			label.color = menu.selectedItemColor;
		else
			label.color = menu.normalItemColor;

		if (!prevIsInteractTarget && isInteractTarget && menu.waveSelectedItem)
			label.playWaveAnimation(4.0, 0.25, 2.0);
		else if (!isInteractTarget || !menu.waveSelectedItem)
			label.resetWaveAnimation();

		// Make the label have arrow icons if it is a button and selected
		if (data.type == BUTTON)
		{
			if (!prevIsInteractTarget && isInteractTarget)
			{
				label.setText(">" + data.label + "<");

				/* FlxSpriteGroup colors don't automatically update when new members are added. Nor do they update if
					you try to assign the same color. Therefore, you need to do this to make sure all characters are the same color */
				var color:FlxColor = label.color;
				label.color = FlxColor.BLACK;
				label.color = color;
			}
			else if (prevIsInteractTarget && !isInteractTarget)
				label.setText(data.label);
		}

		if (!prevIsInteractTarget && isInteractTarget && menu.selectSound != null && !tempDisableSelectSound)
			menu.selectSound.play();
		tempDisableSelectSound = false;

		prevIsInteractTarget = isInteractTarget;
	}
}
