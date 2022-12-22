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
		super(album.name, functions);
		this.album = album;

		// Create the album sprite and make it appear behind the button
		albumSprite = new AssetSprite(x, y, album.spriteID);
		albumSprite.updateHitbox();
		insert(0, albumSprite);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		label.visible = isSelected;

		// Scale the album out as the menu item fades
		albumSprite.scale.set(1.0 - (1.0 - alpha) * 0.5, 1.0 - (1.0 - alpha) * 0.5);
		albumSprite.offset.set(albumSprite.width / 2.0 * albumSprite.scale.x, albumSprite.height / 2.0 * albumSprite.scale.y);
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);
		// Remove the arrows
		leftmostArrow.kill();
		rightmostArrow.kill();
	}

	public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		if (flashingTime < 0.0)
			albumSprite.angle = 360.0 * beat * album.spriteSpinSpeed;
	}

	public function onWholeBeat(beat:Int) {}
}
