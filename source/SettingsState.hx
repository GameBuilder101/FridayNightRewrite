package;

import flixel.FlxG;
import menu.MenuItem;
import menu.MenuState;
import menu.items.ButtonMenuItem;

class SettingsState extends MenuState
{
	function getMenuID():String
	{
		return "settings";
	}

	override function getMenuItems():Array<MenuItem>
	{
		return getMainMenuItems();
	}

	override function getTitle():String
	{
		return stage.data.name;
	}

	function getMainMenuItems():Array<MenuItem>
	{
		return [
			{
				type: ButtonMenuItem,
				label: "Controls",
				onInteracted: function(value:Dynamic)
				{
					menu.createItems(getControlsMenuItems());
				}
			},
			{
				type: ButtonMenuItem,
				label: "Graphics & Sound",
				onInteracted: function(value:Dynamic)
				{
					menu.createItems(getGraphicsMenuItems());
				}
			},
			{
				type: ButtonMenuItem,
				label: "Gameplay",
				onInteracted: function(value:Dynamic)
				{
					menu.createItems(getGameplayMenuItems());
				}
			},
			{
				type: ButtonMenuItem,
				label: "Back",
				onInteracted: function(value:Dynamic)
				{
					FlxG.switchState(new TitleScreenState());
				},
				isCancelItem: true
			}
		];
	}

	function getControlsMenuItems():Array<MenuItem>
	{
		return [
			{
				type: ButtonMenuItem,
				label: "Back",
				onSelected: function()
				{
					currentHint = "";
				},
				onInteracted: function(value:Dynamic)
				{
					menu.createItems(getMainMenuItems());
					currentHint = "";
				},
				isCancelItem: true
			}
		];
	}

	function getGraphicsMenuItems():Array<MenuItem>
	{
		return [
			{
				type: ButtonMenuItem,
				label: "Back",
				onSelected: function()
				{
					currentHint = "";
				},
				onInteracted: function(value:Dynamic)
				{
					menu.createItems(getMainMenuItems());
					currentHint = "";
				},
				isCancelItem: true
			}
		];
	}

	function getGameplayMenuItems():Array<MenuItem>
	{
		return [
			{
				type: ButtonMenuItem,
				label: "Back",
				onSelected: function()
				{
					currentHint = "";
				},
				onInteracted: function(value:Dynamic)
				{
					menu.createItems(getMainMenuItems());
					currentHint = "";
				},
				isCancelItem: true
			}
		];
	}
}
