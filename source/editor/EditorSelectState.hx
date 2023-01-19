package editor;

import assetManagement.LibraryManager;
import flixel.FlxG;
import menu.MenuItem;
import menu.MenuState;
import menu.items.ButtonMenuItem;
import menu.items.LabelMenuItem;

class EditorSelectState extends MenuState
{
	override function create()
	{
		super.create();

		currentTitle = stage.data.name; // Use the stage name as the display name
		currentHint = null;

		menu.addItems(getMainMenuItems());
	}

	function getMenuID():String
	{
		return "editor_select";
	}

	function getMainMenuItems():Array<MenuItem>
	{
		return [
			new LabelMenuItem("- Basic -"),
			new ButtonMenuItem("Asset-Sprite", {
				onSelected: function()
				{
					currentHint = "Define the animations and appearence of any sprite";
				}
			}),
			new ButtonMenuItem("Sound", {
				onSelected: function()
				{
					currentHint = "Define volume and variants of a sound effect";
				}
			}),
			new ButtonMenuItem("Music", {
				onSelected: function()
				{
					currentHint = "Define the volume and BPM map of a piece of music. Note: this is NOT the song editor!";
				}
			}),
			new LabelMenuItem("- Gameplay -"),
			new ButtonMenuItem("Song", {
				onSelected: function()
				{
					currentHint = "The song/chart editor";
				}
			}),
			new ButtonMenuItem("Character", {
				onSelected: function()
				{
					currentHint = "Define what sprites, colors, etc. are associated with a character";
				}
			}),
			new ButtonMenuItem("Stage", {
				onSelected: function()
				{
					currentHint = "The stage/background editor";
				}
			}),
			new LabelMenuItem("- Other -"),
			new ButtonMenuItem("Album", {
				onSelected: function()
				{
					currentHint = "Define album appearence and week data";
				}
			}),
			new LabelMenuItem("- Mod -"),
			new ButtonMenuItem("New Mod", {
				onSelected: function()
				{
					currentHint = "Generate a new mod template to start adding content";
				}
			}),
			new ButtonMenuItem("Asset Reload", {
				onSelected: function()
				{
					currentHint = "Performs a full asset database/library reload";
				},
				onInteracted: function(value:Dynamic)
				{
					LibraryManager.fullReload();
				}
			}),
			new ButtonMenuItem("Back", {
				onSelected: function()
				{
					currentHint = null;
				},
				onInteracted: function(value:Dynamic)
				{
					FlxG.switchState(new TitleScreenState());
				}
			}, null, true)
		];
	}
}
