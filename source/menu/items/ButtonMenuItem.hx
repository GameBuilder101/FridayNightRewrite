package menu.items;

import menu.MenuItem;

class ButtonMenuItem extends LabelMenuItem
{
	/** When true, this item can be interacted with using the cancel input. **/
	var useCancel:Bool;

	public var leftmostArrow(default, null):AssetSprite;
	public var rightmostArrow(default, null):AssetSprite;

	public function new(labelText:String, functions:MenuItemFunctions = null, iconID:String = null, useCancel:Bool = false)
	{
		super(labelText, functions, iconID, true);
		this.useCancel = useCancel;
		selectable = true;

		leftmostArrow = new AssetSprite(x, y, "menus/_shared/arrow");
		leftmostArrow.visible = false;
		add(leftmostArrow);

		rightmostArrow = new AssetSprite(x, y, "menus/_shared/arrow");
		rightmostArrow.flipX = true;
		rightmostArrow.visible = false;
		add(rightmostArrow);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		if (interactDelay <= 0.0
			&& ((isSelected && menu.interactable && Controls.accept.check())
				|| (useCancel && menu.interactable && Controls.cancel.check()))) // Cancel items can also be interacted with using cancel input
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
				onInteracted(null);
		}

		// Make the arrows visible and update their colors if selected
		leftmostArrow.visible = isSelected && isInteractTarget && icon == null; // Make sure the left arrow doesn't overlap the icon
		leftmostArrow.color = label.color;
		rightmostArrow.visible = isSelected && isInteractTarget;
		rightmostArrow.color = label.color;
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);

		leftmostArrow.x = x - label.members[0].offset.x - 16.0;
		leftmostArrow.scale.set(menu.fontSize, menu.fontSize);
		leftmostArrow.updateHitbox();
		leftmostArrow.offset.set(leftmostArrow.width, 0.0);

		rightmostArrow.x = x - label.members[0].offset.x + label.width + 16.0;
		rightmostArrow.scale.set(menu.fontSize, menu.fontSize);
		rightmostArrow.updateHitbox();
		rightmostArrow.offset.set(0.0, 0.0);
	}

	override function onInteracted(value:Dynamic)
	{
		if (useCancel)
			menu.playCancelSound();
		else
			menu.playConfirmSound();
		super.onInteracted(value);
	}
}
