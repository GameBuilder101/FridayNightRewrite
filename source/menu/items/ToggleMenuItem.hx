package menu.items;

import menu.MenuItem;

class ToggleMenuItem extends LabelMenuItem
{
	/** Whether the toggle is on or off. **/
	public var on:Bool;

	/** Used to detect changes to the on state. **/
	var prevOn:Bool;

	public var toggle(default, null):AssetSprite;

	public function new(functions:MenuItemFunctions, ?labelText:String, ?iconID:String, useCancel:Bool = false)
	{
		super(functions, labelText, iconID);

		toggle = new AssetSprite(x - 32.0, y, "menus/_shared/toggle");
		toggle.animation.play("idle_off");
		toggle.updateHitbox();
		toggle.offset.set(toggle.width, 0.0);
		add(toggle);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		if (on && !prevOn)
			toggle.animation.play("turning_on");
		else if (on && prevOn)
			toggle.animation.play("turning_off");

		if (isSelected && menu.interactable && Controls.accept.check())
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
				onInteracted(null);
		}

		prevOn = on;
	}

	override function onInteracted(value:Dynamic)
	{
		super.onInteracted(value);
		on = !on;
		menu.playConfirmSound();
	}
}
