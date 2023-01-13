package;

import Album;
import flixel.FlxG;
import menu.MenuState;
import music.Conductor;
import music.MusicData;

class FreeplayState extends MenuState implements IAlbumSelected
{
	/** The album that was selected in the album select state. **/
	public var album:AlbumData;

	override function create()
	{
		super.create();

		// Just in case, play the menu music again
		Conductor.play(MusicDataRegistry.getAsset(album.menuMusicID), true, false);
		background.loadFromID(album.backgroundID);
		background.color = album.backgroundColor;
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
		return "freeplay";
	}
}