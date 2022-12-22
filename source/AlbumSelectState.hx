package;

import Album;
import flixel.FlxG;
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

	public function new(nextState:MenuState)
	{
		super();
		this.nextState = nextState;
	}

	override function create()
	{
		// Load all albums
		for (id in AlbumDataRegistry.getAllIDs())
			albums.push(AlbumDataRegistry.getAsset(id));

		super.create();

		hintBack.setPosition(FlxG.width / 2.0 - FlxG.width / 3.0, FlxG.height - 176.0);
		hintBack.makeGraphic(cast(FlxG.width / 1.5), 160, FlxColor.BLACK);
		hintText.setPosition(hintBack.x + 16.0, hintBack.y + 16.0);
		hintText.fieldWidth = hintBack.width - 32.0;

		currentTitle = stage.data.name;
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

	override function getMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		for (album in albums)
		{
			items.push(new AlbumMenuItem(album, {
				onSelected: function() // When an album is selected, the hint should display the description
				{
					// Tween the background color to the album's background color
					var color:FlxColor = background.color;
					FlxTween.cancelTweensOf(background);
					FlxTween.color(background, 0.5, color, album.backgroundColor);

					// Tween the music to the album's preview music
					Conductor.transitionPlay(MusicDataRegistry.getAsset(album.previewMusicID), true, 1.0);

					currentHint = album.description;
				}
			}));
		}
		return items;
	}
}
