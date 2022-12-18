package menu.items;

class ToggleMenuItem extends LabelMenuItem
{
	/** Whether the toggle is on or off. **/
	public var on:Bool;

	/** Used to detect changes to the on state. **/
	var prevOn:Bool;

	public var toggle(default, null):AssetSprite;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		if (on != prevOn)
			toggle.animation.play("turning_" + on);
		// Cheat-y way of detecting if the current animation is a turning animation and switching to an idle animation
		if (toggle.animation.curAnim.name.charAt(0) == "t")
			toggle.animation.play("idle_" + on);

		if (isSelected && menu.interactable && Controls.accept.check())
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
				onInteracted(null);
		}

		prevOn = on;
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);
		// Create this in addToMenu so the width is correctly calculated with the font size obtained from menu
		if (toggle == null)
		{
			toggle = new AssetSprite(x + label.width + 16.0, y, "menus/_shared/toggle");
			toggle.animation.play("idle_off");
			toggle.updateHitbox();
			add(toggle);
		}
	}

	override function onInteracted(value:Dynamic)
	{
		super.onInteracted(value);
		on = !on;
		menu.playToggleSound();
	}
}
