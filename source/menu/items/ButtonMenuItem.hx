package menu.items;

import flixel.FlxG;
import menu.MenuItem;

class ButtonMenuItem extends LabelMenuItem
{
	public var leftmostArrow(default, null):AssetSprite;
	public var rightmostArrow(default, null):AssetSprite;

	public function new(menu:Menu, index:Int, data:MenuItemData)
	{
		super(menu, index, data);

		leftmostArrow = new AssetSprite(x - 16.0, y, "menus/_shared/arrow");
		leftmostArrow.updateHitbox();
		leftmostArrow.offset.set(leftmostArrow.width, 0.0);
		leftmostArrow.visible = false;
		add(leftmostArrow);

		rightmostArrow = new AssetSprite(x + label.width + 16.0, y, "menus/_shared/arrow");
		rightmostArrow.updateHitbox();
		rightmostArrow.flipX = true;
		rightmostArrow.visible = false;
		add(rightmostArrow);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		// Make the buttons visible and update their colors if selected
		leftmostArrow.visible = isSelected && isInteractTarget && icon == null; // Make sure the left arrow doesn't overlap the icon
		leftmostArrow.color = label.color;
		rightmostArrow.visible = isSelected && isInteractTarget;
		rightmostArrow.color = label.color;

		if ((isSelected && menu.interactable && Controls.accept.check())
			|| (data.isCancelItem && menu.interactable && Controls.cancel.check())) // Cancel items can also be interacted with using cancel input
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
				onInteracted(null);
		}
	}

	override function onInteracted(value:Dynamic)
	{
		super.onInteracted(value);
		if (data.isCancelItem)
			menu.playCancelSound();
		else
			menu.playConfirmSound();
	}
}
