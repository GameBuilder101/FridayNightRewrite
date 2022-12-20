package menu.items;

import menu.MenuItem;
import Controls;

/** A menu item that allows the user to override an action/control. **/
class ControlMenuItem extends LabelMenuItem
{
	/** The target action to override. **/
	var action(default, null):OverridableAction;

	public function new(action:OverridableAction, functions:MenuItemFunctions, iconID:String = null)
	{
		super(functions, action.displayName, iconID);
		this.action = action;
	}
}
