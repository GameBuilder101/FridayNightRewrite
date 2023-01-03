package;

import AssetSprite;
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

class AlbumSelectState extends MenuState
{
	var nextState:MenuState;

	/** An array of all detected/loaded albums. **/
	public var albums(default, null):Array<AlbumData> = [];

	var leftMenuArrow:FlxSprite;
	var rightMenuArrow:FlxSprite;

	public function new(nextState:MenuState)
	{
		super();
		this.nextState = nextState;
	}

	override function create()
	{
		super.create();

		// Get all albums IDs
		var allIDs:Array<String> = AlbumDataRegistry.getAllIDs();
		// Make the priority albums appear first in the list (in the order specified in the array)
		for (id in cast(data.priorityAlbumOrder, Array<Dynamic>))
		{
			if (!allIDs.contains(id))
				continue;
			allIDs.remove(id);
			allIDs.unshift(id);
		}
		// Load albums from the list that was created
		for (id in allIDs)
			albums.push(AlbumDataRegistry.getAsset(id));

		menu.addItems(getMainMenuItems());
		currentTitle = stage.data.name;

		hintBack.setPosition(FlxG.width / 2.0 - FlxG.width / 3.0, FlxG.height - 176.0);
		hintBack.makeGraphic(cast(FlxG.width / 1.5), 160, FlxColor.BLACK);
		hintText.setPosition(hintBack.x + 16.0, hintBack.y + 16.0);
		hintText.fieldWidth = hintBack.width - 32.0;

		var menuArrows:Array<FlxSprite> = stage.getElementsWithTag("left_menu_arrow");
		if (menuArrows.length > 0)
			leftMenuArrow = menuArrows[0];
		menuArrows = stage.getElementsWithTag("right_menu_arrow");
		if (menuArrows.length > 0)
			rightMenuArrow = menuArrows[0];
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
		return "album_select";
	}

	function getMainMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		for (album in albums)
		{
			items.push(new AlbumMenuItem(album, {
				onSelected: function() // When an album is selected, the hint should display the description
				{
					// Tween the background color to the album's background color
					var color:FlxColor = background.color;
					background.loadFromData(AssetSpriteDataRegistry.getAsset(album.backgroundID));
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
					cast(nextState, IAlbumSelected).album = album;
					specialTransition(nextState);
					// Hide the side arrows
					if (leftMenuArrow != null)
						leftMenuArrow.visible = false;
					if (rightMenuArrow != null)
						rightMenuArrow.visible = false;
				}
			}));
		}
		return items;
	}
}
