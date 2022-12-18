package menu.items;

import menu.MenuItem;

class ButtonMenuItem extends LabelMenuItem
{
	public var leftmostArrow(default, null):AssetSprite;
	public var rightmostArrow(default, null):AssetSprite;

	/** When true, this item can be interacted with using the cancel input. **/
	var useCancel:Bool;

	public function new(functions:MenuItemFunctions, labelText:String, iconID:String = "", useCancel:Bool = false)
	{
		super(functions, labelText, iconID);
		this.useCancel = useCancel;
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
			|| (useCancel && menu.interactable && Controls.cancel.check())) // Cancel items can also be interacted with using cancel input
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
				onInteracted(null);
		}
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);

		// Create this in addToMenu so the width is correctly calculated with the font size obtained from menu
		if (leftmostArrow == null)
		{
			leftmostArrow = new AssetSprite(x - 16.0, y, "menus/_shared/arrow");
			leftmostArrow.updateHitbox();
			leftmostArrow.offset.set(leftmostArrow.width, 0.0);
			leftmostArrow.visible = false;
			add(leftmostArrow);
		}

		if (rightmostArrow == null)
		{
			rightmostArrow = new AssetSprite(x + label.width + 16.0, y, "menus/_shared/arrow");
			rightmostArrow.updateHitbox();
			rightmostArrow.flipX = true;
			rightmostArrow.visible = false;
			add(rightmostArrow);
		}
	}

	override function onInteracted(value:Dynamic)
	{
		super.onInteracted(value);
		if (useCancel)
			menu.playCancelSound();
		else
			menu.playConfirmSound();
	}
}