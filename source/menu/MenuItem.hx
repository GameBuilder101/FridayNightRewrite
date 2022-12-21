package menu;

import flixel.group.FlxSpriteGroup;

abstract class MenuItem extends FlxSpriteGroup
{
	/** The associated menu. **/
	var menu:Menu;

	/** The item's index in the menu. **/
	public var index(default, null):Int;

	/** Whether the menu item should be selectable (meaning it can be "hovered" over). **/
	public var selectable:Bool = true;

	/** Whether the menu item should be interactable. **/
	public var interactable:Bool = true;

	/** For some reason, controls don't immediately register as off after one
		frame (they linger). So in rare instances, an item can be triggered when switching
		in the settings menu, for instance. **/
	public var interactDelay:Float;

	var functions:MenuItemFunctions;

	public function new(functions:MenuItemFunctions = null)
	{
		super(0.0, 0.0);
		this.functions = functions;
		if (functions == null)
			this.functions = {};
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (interactDelay > 0.0)
			interactDelay -= elapsed;
		if (interactDelay < 0.0)
			interactDelay = 0.0;
	}

	/** Call when adding this item to a menu. **/
	public function addToMenu(menu:Menu, index:Int)
	{
		this.menu = menu;
		this.index = index;
		interactDelay = 0.1;
	}

	public function onSelected()
	{
		if (functions.onSelected != null)
			functions.onSelected();
	}

	public function onDeselected()
	{
		if (functions.onDeselected != null)
			functions.onDeselected();
	}

	public function onInteracted(value:Dynamic)
	{
		interactDelay = 0.1;
		if (functions.onInteracted != null)
			functions.onInteracted(value);
	}

	inline function getIsSelected():Bool
	{
		return index == menu.selectedItem;
	}

	/** True when this item and the menu are interactable. **/
	inline function getIsInteractTarget():Bool
	{
		return interactable && menu.interactable;
	}
}

/** Common menu item functions. **/
typedef MenuItemFunctions =
{
	?onSelected:Void->Void,
	?onDeselected:Void->Void,
	?onInteracted:Dynamic->Void
}
