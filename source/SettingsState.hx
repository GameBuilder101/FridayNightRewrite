package;

import flixel.FlxG;
import menu.MenuItem;
import menu.MenuState;
import menu.items.ButtonMenuItem;
import menu.items.ControlMenuItem;
import menu.items.LabelMenuItem;
import menu.items.SelectionMenuItem;
import menu.items.ToggleMenuItem;

class SettingsState extends MenuState
{
	// Cache the various menu items to improve performance
	var mainMenuItems:Array<MenuItem>;
	var controlsMenuItems:Array<MenuItem>;
	var graphicsMenuItems:Array<MenuItem>;
	var gameplayMenuItems:Array<MenuItem>;

	override function create()
	{
		super.create();
		/* Attempting to create the menu items here causes the settings screen to
			take really long to load, so instead just create them when they're required */
		openMainMenu();
	}

	function getMenuID():String
	{
		return "settings";
	}

	function openMainMenu()
	{
		if (mainMenuItems == null)
			mainMenuItems = [
				new ButtonMenuItem("Controls", {
					onInteracted: function(value:Dynamic)
					{
						openControlsMenu();
					}
				}),
				new ButtonMenuItem("Graphics & Sound", {
					onInteracted: function(value:Dynamic)
					{
						openGraphicsMenu();
					}
				}),
				new ButtonMenuItem("Gameplay", {
					onInteracted: function(value:Dynamic)
					{
						openGameplayMenu();
					}
				}),
				new ButtonMenuItem("Back", {
					onInteracted: function(value:Dynamic)
					{
						Controls.instance.save();
						Settings.instance.save();
						FlxG.switchState(new TitleScreenState());
					}
				}, null, true)
			];

		menu.addItems(mainMenuItems);
		currentTitle = stage.data.name; // Use the stage name as the display name
		currentHint = null;
	}

	function openControlsMenu()
	{
		if (controlsMenuItems == null)
			controlsMenuItems = [
				new LabelMenuItem("- Gameplay -"),
				new ControlMenuItem(Controls.noteLeft),
				new ControlMenuItem(Controls.noteDown),
				new ControlMenuItem(Controls.noteUp),
				new ControlMenuItem(Controls.noteRight),
				new LabelMenuItem("- UI -"),
				new ControlMenuItem(Controls.uiLeft),
				new ControlMenuItem(Controls.uiDown),
				new ControlMenuItem(Controls.uiUp),
				new ControlMenuItem(Controls.uiRight),
				new ControlMenuItem(Controls.accept),
				new ControlMenuItem(Controls.cancel),
				new LabelMenuItem("- Volume -"),
				new ControlMenuItem(Controls.volumeUp),
				new ControlMenuItem(Controls.volumeDown),
				new ControlMenuItem(Controls.mute),
				new LabelMenuItem("- Misc -"),
				new ButtonMenuItem("Reset All", {
					onInteracted: function(value:Dynamic)
					{
						Controls.resetOverrides();
						// Update the bind labels to match
						for (item in controlsMenuItems)
						{
							if (!(item is ControlMenuItem))
								continue;
							cast(item, ControlMenuItem).updateBindLabelText();
						}
					}
				}),
				new ButtonMenuItem("Back", {
					onInteracted: function(value:Dynamic)
					{
						openMainMenu();
					}
				}, null, true)
			];

		menu.addItems(controlsMenuItems);
		currentTitle = stage.data.name + " -> Controls";
	}

	function openGraphicsMenu()
	{
		if (graphicsMenuItems == null)
			graphicsMenuItems = [
				new ToggleMenuItem("Anti-aliasing", Settings.getAntialiasing(), {
					onSelected: function()
					{
						currentHint = "When enabled, makes sprites smoother (disable to improve performance)";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setAntialiasing(value);
					}
				}),
				#if ENABLE_SHADER_TOGGLE
				new ToggleMenuItem("Shaders", Settings.getShaders(), {
					onSelected: function()
					{
						currentHint = "Enables fancy effects such as waving sprites (disable to slightly improve performance)";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setShaders(value);
					}
				}),
				#end
				new ToggleMenuItem("Flashing Lights", Settings.getFlashingLights(), {
					onSelected: function()
					{
						currentHint = "Enables flashing lights/effects (note: this is not garunteed to work if custom scripts don't account for it!)";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setFlashingLights(value);
					}
				}),
				new ToggleMenuItem("Camera Bop", Settings.getCameraBop(), {
					onSelected: function()
					{
						currentHint = "Enables the camera zoom animation on songs that plays each beat";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setCameraBop(value);
					}
				}),
				new SelectionMenuItem("Miss Sound Volume", ["0", "20", "40", "60", "80", "100"], cast(Settings.getMissSoundVolume() * 5.0), {
					onSelected: function()
					{
						currentHint = "Volume of the sound played when missing a note";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setMissSoundVolume(value * 0.2);
					}
				}),
				new ButtonMenuItem("Back", {
					onSelected: function()
					{
						currentHint = null;
					},
					onInteracted: function(value:Dynamic)
					{
						openMainMenu();
					}
				}, null, true)
			];

		menu.addItems(graphicsMenuItems);
		currentTitle = stage.data.name + " -> Graphics & Sound";
	}

	function openGameplayMenu()
	{
		if (gameplayMenuItems == null)
			gameplayMenuItems = [
				new ToggleMenuItem("Downscroll", Settings.getDownscroll(), {
					onSelected: function()
					{
						currentHint = "When enabled, notes move down the screen instead of up";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setDownscroll(value);
					}
				}),
				new ToggleMenuItem("Ghost Tapping", Settings.getGhostTapping(), {
					onSelected: function()
					{
						currentHint = "When enabled, pressing a note without actually hitting one won't count as a miss";
					},
					onInteracted: function(value:Dynamic)
					{
						Settings.setGhostTapping(value);
					}
				}),
				new ButtonMenuItem("Back", {
					onSelected: function()
					{
						currentHint = null;
					},
					onInteracted: function(value:Dynamic)
					{
						openMainMenu();
					}
				}, null, true)
			];

		menu.addItems(gameplayMenuItems);
		currentTitle = stage.data.name + " -> Gameplay";
	}
}
