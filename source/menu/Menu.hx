package menu;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menu.MenuItem;
import stage.Stage;

class Menu extends FlxSpriteGroup
{
	/** The type of menu. **/
	public var menuType(default, null):MenuType;

	public var items(default, null):Array<MenuItem> = new Array<MenuItem>();

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

	/** The minimum alpha a menu item can be. **/
	public var minimumAlpha:Float = 0.25;

	public var selectSound:SoundData;
	public var confirmSound:SoundData;
	public var cancelSound:SoundData;
	public var errorSound:SoundData;

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
		if (interactable)
		{
			if (FlxG.keys.justPressed.UP)
				moveSelection(-1);
			else if (FlxG.keys.justPressed.DOWN)
				moveSelection(1);
		}
	}

	/** Destroys any existing items and creates menus items from the given array. **/
	public function createItems(itemDatas:Array<MenuItemData>)
	{
		// Reset any existing items
		for (item in items)
		{
			remove(item, true);
			item.destroy();
		}
		items = [];

		var i:Int = 0;
		// Create the menu items
		for (itemData in itemDatas)
		{
			items.push(Type.createInstance(itemData.type, [this, i, itemData]));
			add(items[items.length - 1]);
			i++;
		}
		selectedItem = 0;
		tweenItems();
	}

	/** Moves the selected item in the given direction. **/
	public function moveSelection(dir:Int)
	{
		selectedItem += dir;
		if (selectedItem < 0)
			selectedItem = items.length - 1;
		if (selectedItem >= items.length)
			selectedItem = 0;
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
			FlxTween.linearMotion(item, item.x, item.y, targetX, targetY, 0.2, {ease: FlxEase.smoothStepOut});

			// Make items fade out as they move away from the selected item
			targetAlpha = 1.0 - Math.abs(offsetFromSelected) * 0.5;
			if (targetAlpha < minimumAlpha)
				targetAlpha = minimumAlpha;
			FlxTween.tween(item, {alpha: targetAlpha}, 0.2, {ease: FlxEase.smoothStepOut});

			i++;
		}
	}

	/** Either enables or disables interaction with a menu item. **/
	public function setItemInteractable(itemIndex:Int, interactable:Bool)
	{
		items[itemIndex].interactable = interactable;
	}
}

enum MenuType
{
	LIST;
	LIST_DIAGONAL;
	LIST_HORIZONTAL;
	RADIAL;
}
