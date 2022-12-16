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
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(getControlsMenuItems());
				}
			}, "Controls"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(getGraphicsMenuItems());
				}
			}, "Graphics & Sound"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(getGameplayMenuItems());
				}
			}, "Gameplay"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Controls.instance.save();
					Settings.instance.save();
					FlxG.switchState(new TitleScreenState());
				}
			}, "Back", "", true)
		];
	}

	function getControlsMenuItems():Array<MenuItem>
	{
		return [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(getMainMenuItems());
					currentHint = null;
				}
			}, "Back", "", true)
		];
	}

	function getGraphicsMenuItems():Array<MenuItem>
	{
		return [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(getMainMenuItems());
					currentHint = null;
				}
			}, "Back", "", true)
		];
	}

	function getGameplayMenuItems():Array<MenuItem>
	{
		return [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(getMainMenuItems());
					currentHint = null;
				}
			}, "Back", "", true)
		];
	}
}
