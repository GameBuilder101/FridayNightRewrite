package menu.items;

import menu.MenuItem;

/** A general menu-item which uses sprite-text labels. Has no interaction functionality. **/
class LabelMenuItem extends MenuItem
{
	/** Is the element which gets re-colored on update. **/
	public var label(default, null):SpriteText;

	public var icon(default, null):AssetSprite;

	var tempDisableSelectSound:Bool;

	public function new(labelText:String, functions:MenuItemFunctions = null, iconID:String = null, bold:Bool = false)
	{
		super(functions);
		selectable = false; // By default, a label is not selectable
		// Prevent the select sound from playing if this is the initially-selected menu item
		tempDisableSelectSound = true;

		label = new SpriteText(x, y, labelText, 1.0, LEFT, bold);
		add(label);

		if (iconID != null)
		{
			icon = new AssetSprite(x - label.members[0].offset.x - 16.0, y, iconID);
			if (icon.animation.exists("menu_idle"))
				icon.animation.play("menu_idle");
			icon.updateHitbox();
			add(icon);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		tempDisableSelectSound = false;

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

		label.setTextAlign(menu.menuType == RADIAL || menu.menuType == LIST_DIAGONAL ? LEFT : CENTER);
		label.setFont(label.font, menu.fontSize);

		if (icon != null)
		{
			icon.scale.set(menu.fontSize, menu.fontSize);
			icon.updateHitbox();
		}
	}

	public override function onSelected()
	{
		if (!tempDisableSelectSound)
			menu.playSelectSound();
		super.onSelected();
	}
}
