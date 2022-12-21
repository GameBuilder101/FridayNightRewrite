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

	var functions:MenuItemFunctions;

	public function new(functions:MenuItemFunctions = null)
	{
		super(0.0, 0.0);
		this.functions = functions;
		if (functions == null)
			this.functions = {};
	}

	/** Call when adding this item to a menu. **/
	public function addToMenu(menu:Menu, index:Int)
	{
		this.menu = menu;
		this.index = index;
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
