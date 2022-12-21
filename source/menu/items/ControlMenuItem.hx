package menu.items;

import Controls;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import menu.MenuItem;

/** A menu item that allows the user to override an action/control. **/
class ControlMenuItem extends LabelMenuItem
{
	/** The target action to override. **/
	public var action(default, null):OverridableAction;

	/** The index of the currently-selected bind **/
	public var selectedBind(default, null):Int;

	/** True if the user has interacted with this item and is overriding a bind. **/
	public var inRebindMode(default, null):Bool;

	public var bind1Label(default, null):SpriteText;

	var orText:SpriteText;

	public var bind2Label(default, null):SpriteText;

	/** For some reason, controls don't immediately register as off after one
		frame (they linger). So use this to avoid immediate rebinding to the accept key. **/
	var interactDelay:Float;

	public function new(action:OverridableAction, functions:MenuItemFunctions = null, iconID:String = null)
	{
		super(action.displayName, functions, iconID, true);
		this.action = action;
		selectable = true;

		bind1Label = new SpriteText(x, y, "");
		add(bind1Label);

		if (action.maxBinds > 1)
		{
			orText = new SpriteText(x, y, "or");
			add(orText);

			bind2Label = new SpriteText(x, y, "");
			add(bind2Label);
		}

		updateBindLabelText();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();

		// Make the label have a specific color to stand out more
		label.color = FlxColor.fromString("#e97813");

		if (interactDelay > 0.0)
			interactDelay -= elapsed;

		// Change the selected bind if the left or right button is pressed
		if (!inRebindMode && isSelected)
		{
			if (Controls.uiLeft.check() && selectedBind > 0)
			{
				menu.playSelectSound();
				selectedBind--;
			}
			else if (Controls.uiRight.check() && selectedBind < action.maxBinds - 1)
			{
				menu.playSelectSound();
				selectedBind++;
			}
		}

		if (interactDelay <= 0.0 && !inRebindMode && isSelected && getIsInteractTarget() && Controls.accept.check())
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
			{
				menu.playToggleSound();
				enterRebindMode();
			}
		}

		if (interactDelay <= 0.0 && inRebindMode)
			updateRebindMode();

		updateBindLabelAppearance(bind1Label, isSelected && selectedBind == 0);
		updateBindLabelAppearance(bind2Label, isSelected && selectedBind == 1);
	}

	/** Make the binds either the selected color or normal item color if they are selected. **/
	function updateBindLabelAppearance(label:SpriteText, isSelected:Bool)
	{
		if (label == null)
			return;
		if (isSelected && !label.bold)
		{
			label.color = menu.selectedItemColor;
			label.setBold(true);
		}
		else if (!isSelected && label.bold)
		{
			label.color = menu.normalItemColor;
			label.setBold(false);
		}
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);
		interactDelay = 0.1;

		bind1Label.x = x - label.members[0].offset.x + label.width + 48.0;
		bind1Label.setFont(bind1Label.font, menu.fontSize);

		if (action.maxBinds > 1)
		{
			orText.setFont(orText.font, menu.fontSize * 0.75);
			orText.color = menu.normalItemColor;

			bind2Label.setFont(bind2Label.font, menu.fontSize);

			updateExtraLabelPositions();
		}
	}

	inline function updateExtraLabelPositions()
	{
		if (action.maxBinds <= 1)
			return;
		orText.x = bind1Label.x + bind1Label.width + 32.0;
		bind2Label.x = orText.x + orText.width + 32.0;
	}

	/** Enters rebind mode, where the menu waits for an input and overrides this item's action. **/
	public function enterRebindMode()
	{
		if (inRebindMode)
			return;
		inRebindMode = true;
		menu.interactable = false;
		interactDelay = 0.1;
	}

	/** Exits rebind mode. **/
	public function exitRebindMode()
	{
		if (!inRebindMode)
			return;
		inRebindMode = false;
		menu.interactable = true;
		interactDelay = 0.1;
	}

	function updateRebindMode()
	{
		// If using gamepad, check for a gamepad input instead
		if (FlxG.gamepads.numActiveGamepads > 0)
		{
			// Get the gamepad button that was just pressed (assuming there is one)
			var gamepad:FlxGamepadInputID = FlxG.gamepads.firstActive.firstJustPressedID();
			if (gamepad == NONE)
				return;
			// Override the gamepad button
			action.overrideGamepad(selectedBind, gamepad);
		}
		else
		{
			// Get the key that was just pressed (assuming there is one)
			var key:FlxKey = FlxG.keys.firstJustPressed();
			if (key == NONE)
				return;
			// Override the key
			action.overrideKey(selectedBind, key);
		}

		updateBindLabelText();
		exitRebindMode();
	}

	/** Update the bind label text. **/
	public function updateBindLabelText()
	{
		if (FlxG.gamepads.numActiveGamepads > 0)
		{
			bind1Label.setText(action.getGamepadBind(0));
			if (bind2Label != null)
				bind2Label.setText(action.getGamepadBind(1));
		}
		else
		{
			bind1Label.setText(action.getKeyBind(0));
			if (bind2Label != null)
				bind2Label.setText(action.getKeyBind(1));
		}

		updateExtraLabelPositions();
	}
}
