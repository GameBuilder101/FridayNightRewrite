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
		var isInteractTarget:Bool = getIsInteractTarget();

		// Make the buttons visible and update their colors if selected
		leftmostArrow.visible = isInteractTarget;
		leftmostArrow.color = label.color;
		rightmostArrow.visible = isInteractTarget;
		rightmostArrow.color = label.color;

		if (getIsSelected() && FlxG.keys.justPressed.ENTER)
		{
			if (!interactable)
				menu.errorSound.play(); // Play the error sound if not interactable
			else if (isInteractTarget)
			{
				if (data.onInteracted != null)
					data.onInteracted(null); // Call the interact function
				menu.confirmSound.play();
				onInteracted();
			}
		}
	}

	function onInteracted() {}
}
