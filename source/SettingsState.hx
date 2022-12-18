package;

import flixel.FlxG;
import menu.MenuItem;
import menu.MenuState;
import menu.items.ButtonMenuItem;

class SettingsState extends MenuState
{
	var mainMenuItems:Array<MenuItem>;
	var controlsMenuItems:Array<MenuItem>;
	var graphicsMenuItems:Array<MenuItem>;
	var gameplayMenuItems:Array<MenuItem>;

	public function new()
	{
		super();

		mainMenuItems = [
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(controlsMenuItems);
				}
			}, "Controls"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(graphicsMenuItems);
				}
			}, "Graphics & Sound"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(gameplayMenuItems);
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

		controlsMenuItems = [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(mainMenuItems);
					currentHint = null;
				}
			}, "Back", "", true)
		];

		graphicsMenuItems = [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(mainMenuItems);
					currentHint = null;
				}
			}, "Back", "", true)
		];

		gameplayMenuItems = [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					menu.addItems(mainMenuItems);
					currentHint = null;
				}
			}, "Back", "", true)
		];
	}

	function getMenuID():String
	{
		return "settings";
	}

	override function getMenuItems():Array<MenuItem>
	{
		return mainMenuItems;
	}

	override function getTitle():String
	{
		return stage.data.name;
	}
}
