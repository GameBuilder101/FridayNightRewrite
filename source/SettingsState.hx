package;

import flixel.FlxG;
import menu.MenuItem;
import menu.MenuState;
import menu.items.ButtonMenuItem;
import menu.items.SelectionMenuItem;
import menu.items.ToggleMenuItem;
import menu.items.ControlMenuItem;

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
			new ControlMenuItem(Controls.volumeUp, {
				onSelected: function()
				{
					currentHint = "Increases game volume";
				}
			}),
			new ControlMenuItem(Controls.volumeDown, {
				onSelected: function()
				{
					currentHint = "Decreases game volume";
				}
			}),
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
			new SelectionMenuItem({
				onInteracted: function(value:Dynamic)
				{
					Settings.instance.set(Settings.MISS_SOUND_VOLUME, Std.parseFloat(value));
				}
			}, "Miss Sound Volume", null,
				["0", "0.2", "0.4", "0.6", "0.8", "1"], Settings.getMissSoundVolume() + ""),
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
