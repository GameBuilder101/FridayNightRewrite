package menu.items;

import menu.MenuItem;

/** A general menu-item which uses sprite-text labels. Has no interaction functionality. **/
class LabelMenuItem extends MenuItem
{
	/** Is the element which gets re-colored on update. **/
	public var label(default, null):SpriteText;

	var labelText(default, null):String;

	public var icon(default, null):AssetSprite;

	var tempDisableSelectSound:Bool;

	public function new(functions:MenuItemFunctions, labelText:String, iconID:String = "")
	{
		super(functions);
		// Prevent the select sound from playing if this is the initially-selected menu item
		tempDisableSelectSound = true;

		this.labelText = labelText;

		if (iconID != null && iconID != "")
		{
			icon = new AssetSprite(x, y, iconID);
			if (icon.animation.exists("menu_idle"))
				icon.animation.play("menu_idle");
			icon.updateHitbox();
			add(icon);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		tempDisableSelectSound = false;

		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		if (!interactable)
			label.color = menu.disabledItemColor;
		else if (isSelected && isInteractTarget)
			label.color = menu.selectedItemColor;
		else
			label.color = menu.normalItemColor;

		if (menu.waveSelectedItem && isSelected && isInteractTarget && !label.getIsWaving())
			label.playWaveAnimation(3.0, 0.4);
		else if (!menu.waveSelectedItem || !isSelected || !isInteractTarget)
			label.resetWaveAnimation();
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);
		if (label == null)
		{
			label = new SpriteText(x, y, labelText, menu.fontSize, menu.menuType == RADIAL
				|| menu.menuType == LIST_DIAGONAL ? LEFT : CENTER, true);
			add(label);
		}
	}

	public override function onSelected()
	{
		super.onSelected();
		if (!tempDisableSelectSound)
			menu.playSelectSound();
	}
}
