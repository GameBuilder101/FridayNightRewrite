package menu.items;

import Album;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import menu.MenuItem;

/** Used for album selection in the AlbumSelectState. **/
class AlbumMenuItem extends FlashingButtonMenuItem
{
	/** The album this item is associated with. **/
	public var album(default, null):AlbumData;

	public var albumSprite(default, null):AssetSprite;

	public function new(album:AlbumData, functions:MenuItemFunctions = null)
	{
		super(album.name, functions);
		this.album = album;

		// Create the album sprite and make it appear behind the button
		albumSprite = new AssetSprite(x, y + 30.0, album.spriteID);
		insert(0, albumSprite);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		label.visible = isSelected;

		// Scale the album out as the menu item fades
		albumSprite.scale.set(1.0 - (1.0 - alpha) * 0.5, 1.0 - (1.0 - alpha) * 0.5);
		albumSprite.updateHitbox();
		albumSprite.offset.set(albumSprite.width / 2.0 * albumSprite.scale.x, albumSprite.height / 2.0 * albumSprite.scale.y);

		// Spin the album while not pressed
		if (flashingTime < 0.0)
			albumSprite.angle += elapsed;
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);
		// Remove the arrows (album items don't use them)
		leftmostArrow.kill();
		rightmostArrow.kill();
	}

	override function onInteracted(value:Dynamic)
	{
		FlxTween.tween(albumSprite, {angle: albumSprite.angle + 360.0}, 1.0, {ease: FlxEase.expoIn});
		super.onInteracted(value);
	}
}
