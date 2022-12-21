package menu;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menu.MenuItem;
import stage.Stage;

class Menu extends FlxSpriteGroup
{
	/** The type of menu. **/
	public var menuType(default, null):MenuType;

	public var items(default, null):Array<MenuItem> = [];

	/** The index of the currently-selected/hovered item. **/
	public var selectedItem(default, null):Int;

	/** Whether the whole menu should be interactable. **/
	public var interactable:Bool = true;

	public var spacing:Float;

	/** Used for radial and diagonal menus. **/
	public var radius:Float;

	public var fontSize(default, null):Float = 1.0;
	public var waveSelectedItem(default, null):Bool;

	/** The normal menu item color. **/
	public var normalItemColor:FlxColor = FlxColor.WHITE;

	/** The selected menu item color. **/
	public var selectedItemColor:FlxColor = FlxColor.WHITE;

	/** The disabled menu item color. **/
	public var disabledItemColor:FlxColor = FlxColor.WHITE;

	/** The minimum alpha used when fading out distant items. **/
	public var minimumAlpha:Float = 0.25;

	/** The minimum scale used when scaling out distant items. **/
	public var minimumScale:Float = 1.0;

	public var selectSound:SoundData;
	public var confirmSound:SoundData;
	public var cancelSound:SoundData;
	public var errorSound:SoundData;
	public var toggleSound:SoundData;

	var menuSounds:FlxSound = new FlxSound();

	/** The stage this menu is associated with. Used for visual effects such as flashing when a button is pressed. **/
	public var stage(default, null):Stage;

	public function new(x:Float, y:Float, menuType:MenuType = LIST, stage:Stage = null)
	{
		super(x, y);
		this.menuType = menuType;
		this.stage = stage;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!interactable)
			return;
		if (menuType == LIST_HORIZONTAL)
		{
			if (Controls.uiLeft.check())
				moveSelection(-1);
			else if (Controls.uiRight.check())
				moveSelection(1);
		}
		else
		{
			if (Controls.uiUp.check())
				moveSelection(-1);
			else if (Controls.uiDown.check())
				moveSelection(1);
		}
	}

	/** Destroys any existing items and adds menus items from the given array. **/
	public function addItems(items:Array<MenuItem>)
	{
		// Reset any existing items
		for (item in this.items)
		{
			FlxTween.cancelTweensOf(item);
			remove(item, true);
			item.kill();
		}
		this.items = [];

		if (items == null || items.length <= 0)
			return;

		var i:Int = 0;
		// Create the menu items
		for (item in items)
		{
			item.revive();
			item.addToMenu(this, i);
			add(item);
			this.items.push(item);
			i++;
		}

		// Start with the first (selectable) item selected
		var index:Int = 0;
		while (!items[index].selectable)
			index++;
		selectItem(index);
	}

	/** Moves the selected item in the given direction. **/
	public function moveSelection(dir:Int)
	{
		if (items == null || items.length <= 0)
			return;

		var index:Int = selectedItem + dir;
		if (index < 0)
			index = items.length - 1;
		if (index >= items.length)
			index = 0;

		// Make sure we don't select an non-selectable item
		while (!items[index].selectable)
		{
			index += dir;
			if (index < 0)
				index = items.length - 1;
			if (index >= items.length)
				index = 0;
		}

		selectItem(index);
	}

	function selectItem(index:Int)
	{
		// Deselect the current item
		if (getSelectedItem() != null)
			getSelectedItem().onDeselected();
		// Move to and select the next item
		selectedItem = index;
		getSelectedItem().onSelected();
		tweenItems();
	}

	/** Plays a tween on any items to move them to the correct location. **/
	function tweenItems()
	{
		var i:Int = 0;
		var offsetFromSelected:Int;
		var targetX:Float;
		var targetY:Float;
		var targetAlpha:Float;
		var targetScale:Float;
		for (item in items)
		{
			FlxTween.cancelTweensOf(item);

			offsetFromSelected = i - selectedItem;

			// Update the item positions (differently depending on menu type)
			targetX = x;
			targetY = y;
			switch (menuType)
			{
				case LIST:
					targetY += offsetFromSelected * spacing;
				case LIST_DIAGONAL:
					targetX += offsetFromSelected * radius;
					targetY += offsetFromSelected * spacing;
				case LIST_HORIZONTAL:
					targetX += offsetFromSelected * spacing;
				case RADIAL:
					// Do some trig
					targetX += FlxMath.fastCos(offsetFromSelected * spacing * Math.PI) * radius;
					targetY += FlxMath.fastSin(offsetFromSelected * spacing * Math.PI) * radius;
			}
			FlxTween.linearMotion(item, item.x, item.y, targetX, targetY, 0.2, {ease: FlxEase.smootherStepOut});

			// Make items fade out/scale down as they move away from the selected item
			targetAlpha = 1.0 - Math.abs(offsetFromSelected) * 0.5;
			if (targetAlpha < minimumAlpha)
				targetAlpha = minimumAlpha;
			targetScale = targetAlpha;
			if (targetScale < minimumScale)
				targetScale = minimumScale;
			FlxTween.tween(item, {alpha: targetAlpha, "scale.x": targetScale, "scale.y": targetScale}, 0.2, {ease: FlxEase.smoothStepOut});

			i++;
		}
	}

	public inline function getSelectedItem():MenuItem
	{
		return items[selectedItem];
	}

	/** Either enables or disables interaction with a menu item. **/
	public inline function setItemInteractable(itemIndex:Int, interactable:Bool)
	{
		items[itemIndex].interactable = interactable;
	}

	public inline function playSelectSound()
	{
		if (selectSound == null)
			return;
		selectSound.playOn(menuSounds);
	}

	public inline function playConfirmSound()
	{
		if (confirmSound == null)
			return;
		confirmSound.playOn(menuSounds);
	}

	public inline function playCancelSound()
	{
		if (cancelSound == null)
			return;
		cancelSound.playOn(menuSounds);
	}

	public inline function playErrorSound()
	{
		if (errorSound == null)
			return;
		errorSound.playOn(menuSounds);
	}

	public inline function playToggleSound()
	{
		if (toggleSound == null)
			return;
		toggleSound.playOn(menuSounds);
	}
}

enum MenuType
{
	LIST;
	LIST_DIAGONAL;
	LIST_HORIZONTAL;
	RADIAL;
}
