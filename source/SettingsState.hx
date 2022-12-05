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

	override function getMenuItems():Array<MenuItemData>
	{
		return [
			{
				type: ButtonMenuItem,
				label: "Controls"
			},
			{
				type: ButtonMenuItem,
				label: "Graphics & Sound"
			},
			{
				type: ButtonMenuItem,
				label: "Gameplay"
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

	override function getTitle():String
	{
		return stage.data.name;
	}
}
