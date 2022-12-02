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
		if (data.isCancelItem == null)
			data.isCancelItem = false;
	}

	inline function getIsSelected():Bool
	{
		return index == menu.selectedItem;
	}

	/** True when selected and interactable. **/
	inline function getIsInteractTarget():Bool
	{
		return getIsSelected() && interactable && menu.interactable;
	}
}

typedef MenuItemData =
{
	type:Class<MenuItem>,
	label:String,
	?iconID:String,
	?onSelected:Void->Void,
	?onInteracted:Dynamic->Void,
	?isCancelItem:Bool
}
