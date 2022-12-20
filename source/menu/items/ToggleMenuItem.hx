package menu.items;

import menu.MenuItem;

using StringTools;

class ToggleMenuItem extends LabelMenuItem
{
	/** Whether the toggle is on or off. **/
	public var on:Bool;

	/** Used to detect changes to the on state. **/
	var prevOn:Bool;

	public var toggle(default, null):AssetSprite;

	public function new(functions:MenuItemFunctions, labelText:String, iconID:String = null, defaultState:Bool = false)
	{
		super(functions, labelText, iconID);
		on = defaultState;

		toggle = new AssetSprite(x, y, "menus/_shared/toggle");
		toggle.animation.play("idle_" + on);
		add(toggle);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();

		if (isSelected && menu.interactable && Controls.accept.check())
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
			{
				on = !on;
				onInteracted(on);
			}
		}

		if (prevOn != on)
		{
			prevOn = on;
			toggle.animation.play("turning_" + on);
		}

		// Detect if the current animation is a turning animation and switching to an idle animation
		if (toggle.animation.name.startsWith("turning_") && toggle.animation.finished)
			toggle.animation.play("idle_" + on);
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);

		toggle.x = x - label.members[0].offset.x + label.width + 16.0;
		toggle.scale.set(menu.fontSize, menu.fontSize);
		toggle.updateHitbox();
	}

	override function onInteracted(value:Dynamic)
	{
		menu.playToggleSound();
		super.onInteracted(value);
	}
}
