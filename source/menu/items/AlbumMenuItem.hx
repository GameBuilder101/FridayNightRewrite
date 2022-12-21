package menu.items;

import Album;
import menu.MenuItem;
import music.IConducted;

/** Used for album selection in the AlbumSelectState. **/
class AlbumMenuItem extends FlashingButtonMenuItem implements IConducted
{
	/** The album this item is associated with. **/
	public var album(default, null):AlbumData;

	public var albumSprite(default, null):AssetSprite;

	public function new(album:AlbumData, functions:MenuItemFunctions = null)
	{
		this.album = album;

		// Create the album sprite first so it appears behind the button
		albumSprite.scale.set(0.5, 0.5);
		albumSprite = new AssetSprite(x, y, album.spriteID);
		albumSprite.updateHitbox();
		albumSprite.offset.set(albumSprite.width / 2.0, albumSprite.height / 2.0);
		add(albumSprite);

		super(album.name, functions);
	}

	public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		// Use the flashing time to make the album do a quick spin after being selected
		var mult:Float = 1.0;
		if (flashingTime >= 0.0)
		{
			mult = (1.0 - flashingTime) * 2.0;
			if (mult < 0.0)
				mult = 0.0;
		}
		angle = 360.0 * beat * album.spriteSpinSpeed * mult;
	}

	public function onWholeBeat(beat:Int) {}
}
