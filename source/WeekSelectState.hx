package;

import Album;
import AssetSprite;
import GlobalScript;
import Week;
import flixel.FlxG;
import flixel.util.FlxColor;
import menu.MenuItem;
import menu.MenuState;
import menu.items.FlashingButtonMenuItem;
import music.Conductor;
import music.MusicData;

class WeekSelectState extends MenuState implements IAlbumSelected
{
	/** The album that was selected in the album select state. **/
	public var album:AlbumData;

	/** An array of all detected/loaded weeks. **/
	public var weeks(default, null):Array<WeekData> = [];

	override function create()
	{
		super.create();

		Conductor.play(MusicDataRegistry.getAsset(album.menuMusicID), true, false); // Just in case, play the menu music again
		background.loadFromData(AssetSpriteDataRegistry.getAsset(album.backgroundID));
		background.color = album.backgroundColor;

		// Load weeks from the list in the album
		for (id in album.weekIDs)
			weeks.push(WeekDataRegistry.getAsset(id));

		menu.addItems(getMainMenuItems());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Go back to the main menu if the back button is pressed
		if (menu.interactable && Controls.cancel.check())
		{
			menu.playCancelSound();
			FlxG.switchState(new TitleScreenState());
		}
	}

	function getMenuID():String
	{
		return "week_select";
	}

	function getMainMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		for (week in weeks)
		{
			items.push(new FlashingButtonMenuItem(week.itemName, {
				onSelected: function()
				{
					GlobalScriptRegistry.callAll("onWeekSelected", [week]);
				},
				onInteracted: function(value:Dynamic)
				{
					GlobalScriptRegistry.callAll("onWeekInteracted", [week]);
					specialTransition(new PlayState());
				}
			}));
		}
		return items;
	}
}
