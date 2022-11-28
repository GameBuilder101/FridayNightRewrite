package menu;

import flixel.group.FlxSpriteGroup;

abstract class MenuItem extends FlxSpriteGroup
{
	var menu(default, null):Menu;

	/** The item's index in the menu. **/
	var index(default, null):Int;

	/** The data for the menu item. **/
	var data(default, null):MenuItemData;

	/** Whether the menu item should be interactable. **/
	public var interactable:Bool = true;

	public function new(menu:Menu, index:Int, data:MenuItemData)
	{
		super(0.0, 0.0);
		this.menu = menu;
		this.index = index;
		this.data = data;
	}

	public inline function getItemType():MenuItemType
	{
		return data.type;
	}

	inline function getIsSelected():Bool
	{
		return index == menu.selectedItem;
	}

	/** True when selected and interactable. **/
	inline function getIsInteractTarget():Bool
	{
		return getIsSelected() && interactable;
	}
}

enum MenuItemType
{
	LABEL;
	BUTTON;
	TOGGLE;
	SELECTION;
	CONTROL_SCHEME;
}

typedef MenuItemData =
{
	skin:Class<MenuItem>,
	type:MenuItemType,
	label:String,
	iconID:String,
	onSelected:Void->Void,
	onInteracted:Dynamic->Void
}
