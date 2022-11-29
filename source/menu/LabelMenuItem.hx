package menu;

import menu.MenuItem;

/** A type of menu item skin which uses sprite-text labels. **/
class LabelMenuItem extends MenuItem
{
	public var label(default, null):SpriteText;
	public var icon(default, null):AssetSprite;

	var playedSelectSound:Bool;

	public function new(menu:Menu, index:Int, data:MenuItemData)
	{
		super(menu, index, data);
		// Prevent the select sound from playing if this is the initially-selected menu item
		playedSelectSound = true;

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

		if (isInteractTarget && !playedSelectSound && menu.selectSound != null)
		{
			menu.selectSound.play();
			playedSelectSound = true;
		}
		else if (!isInteractTarget)
			playedSelectSound = false;
	}
}
