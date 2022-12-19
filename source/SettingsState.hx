package;

import flixel.FlxG;
import menu.MenuItem;
import menu.MenuState;
import menu.items.ButtonMenuItem;
import menu.items.ToggleMenuItem;

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
					openControlsMenu();
				}
			}, "Controls"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					openGraphicsMenu();
				}
			}, "Graphics & Sound"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					openGameplayMenu();
				}
			}, "Gameplay"),
			new ButtonMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Controls.instance.save();
					Settings.instance.save();
					FlxG.switchState(new TitleScreenState());
				}
			}, "Back", null, true)
		];

		controlsMenuItems = [
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					openMainMenu();
				}
			}, "Back", null, true)
		];

		graphicsMenuItems = [
			new ToggleMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.ANTIALIASING, value);
				}
			}, "Anti-aliasing", null, Settings.getAntialiasing()),
			#if ENABLE_SHADER_TOGGLE
			new ToggleMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.SHADERS, value);
				}
			}, "Shaders", null, Settings.getShaders()),
			#end
			new ToggleMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.FLASHING_LIGHTS, value);
				}
			}, "Flashing Lights", null, Settings.getFlashingLights()),
			new ToggleMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.CAMERA_BOP, value);
				}
			}, "Camera Bop", null, Settings.getCameraBop()),
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					openMainMenu();
				}
			}, "Back", null, true)
		];

		gameplayMenuItems = [
			new ToggleMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.DOWNSCROLL, value);
				}
			}, "Downscroll", null, Settings.getDownscroll()),
			new ToggleMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.GHOST_TAPPING, value);
				}
			}, "Ghost Tapping", null, Settings.getGhostTapping()),
			new ButtonMenuItem({
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					openMainMenu();
				}
			}, "Back", null, true)
		];
	}

	override function create()
	{
		super.create();
		openMainMenu();
	}

	function getMenuID():String
	{
		return "settings";
	}

	inline function openMainMenu()
	{
		menu.addItems(mainMenuItems);
		currentTitle = stage.data.name;
		currentHint = null;
	}

	inline function openControlsMenu()
	{
		menu.addItems(controlsMenuItems);
		currentTitle = stage.data.name + " -> Controls";
	}

	inline function openGraphicsMenu()
	{
		menu.addItems(graphicsMenuItems);
		currentTitle = stage.data.name + " -> Graphics & Sound";
	}

	inline function openGameplayMenu()
	{
		menu.addItems(gameplayMenuItems);
		currentTitle = stage.data.name + " -> Gameplay";
	}
}
