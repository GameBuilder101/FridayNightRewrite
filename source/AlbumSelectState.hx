package;

import Album;
import GlobalScript;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menu.MenuItem;
import menu.MenuState;
import menu.items.AlbumMenuItem;
import music.Conductor;
import music.MusicData.MusicDataRegistry;
import stage.Stage;

class AlbumSelectState extends MenuState
{
	var nextState:PrePlayState;

	var albumIDs(default, null):Array<String>;

	/** An array of all detected/loaded albums. **/
	public var albums(default, null):Array<AlbumData> = [];

	var leftMenuArrow:AssetSprite;
	var rightMenuArrow:AssetSprite;

	public function new(nextState:PrePlayState)
	{
		super();
		this.nextState = nextState;
	}

	override function create()
	{
		super.create();

		// Get all albums IDs
		albumIDs = AlbumDataRegistry.getAllIDs();
		// Make the priority albums appear first in the list (in the order specified in the array)
		for (id in cast(data.priorityAlbumOrder, Array<Dynamic>))
		{
			if (!albumIDs.contains(id))
				continue;
			albumIDs.remove(id);
			albumIDs.unshift(id);
		}
		// Load albums from the list that was created
		for (id in albumIDs)
			albums.push(AlbumDataRegistry.getAsset(id));

		menu.addItems(getMainMenuItems());
		currentTitle = stage.data.name;

		/* Default the background color to the initial selected album
			(so it doesn't start by fading from white) */
		FlxTween.cancelTweensOf(background);
		background.color = albums[menu.selectedItem].backgroundColor;
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

	override function createStage():Stage
	{
		var stage:Stage = super.createStage();
		leftMenuArrow = cast stage.getElementWithTag("left_menu_arrow");
		rightMenuArrow = cast stage.getElementWithTag("right_menu_arrow");
		return stage;
	}

	function getMenuID():String
	{
		return "album_select";
	}

	function getMainMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		var i:Int = 0;
		for (album in albums)
		{
			items.push(new AlbumMenuItem(album, {
				onSelected: function() // When an album is selected, the hint should display the description
				{
					// Tween the background color to the album's background color
					var color:FlxColor = background.color;
					background.loadFromID(album.backgroundID);
					background.color = color; // Since loading a sprite will reset the color
					FlxTween.cancelTweensOf(background);
					FlxTween.color(background, 0.5, color, album.backgroundColor);

					// Tween the music to the album's menu music
					Conductor.transitionPlay(MusicDataRegistry.getAsset(album.menuMusicID), true, 1.0, false);

					currentHint = album.description;

					GlobalScriptRegistry.callAll("onAlbumSelected", [album]);
				},
				onInteracted: function(value:Dynamic)
				{
					GlobalScriptRegistry.callAll("onAlbumInteracted", [album]);
					nextState.albumID = albumIDs[i];
					nextState.album = album;
					specialTransition(nextState);
					// Hide the side arrows
					if (leftMenuArrow != null)
						leftMenuArrow.visible = false;
					if (rightMenuArrow != null)
						rightMenuArrow.visible = false;
				}
			}));
			i++;
		}
		return items;
	}
}
