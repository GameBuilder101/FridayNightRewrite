package menu;

import flixel.group.FlxSpriteGroup;

abstract class MenuItem extends FlxSpriteGroup
{
	var menu:Menu;

	/** The item's index in the menu. **/
	var index:Int;

	/** The data for the menu item. **/
	var data:MenuItemData;

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

	public function onSelected()
	{
		if (data.onSelected != null)
			data.onSelected();
	}

	public function onDeselected()
	{
		if (data.onDeselected != null)
			data.onDeselected();
	}

	public function onInteracted(value:Dynamic)
	{
		if (data.onInteracted != null)
			data.onInteracted(value);
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

typedef MenuItemData =
{
	type:Class<MenuItem>,
	label:String,
	?iconID:String,
	?onSelected:Void->Void,
	?onDeselected:Void->Void,
	?onInteracted:Dynamic->Void,
	?isCancelItem:Bool
}
