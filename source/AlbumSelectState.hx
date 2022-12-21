package;

import Album;
import menu.MenuItem;
import menu.MenuState;
import menu.items.AlbumMenuItem;

class AlbumSelectState extends MenuState
{
	var nextState:MenuState;

	/** An array of all detected/loaded albums. **/
	public var albums(default, null):Array<AlbumData>;

	public function new(nextState:MenuState)
	{
		super();
		this.nextState = nextState;
	}

	override function create()
	{
		super.create();
		currentTitle = stage.data.name;

		// Load all albums
		for (id in AlbumDataRegistry.getAllIDs())
			albums.push(AlbumDataRegistry.getAsset(id));
	}

	function getMenuID():String
	{
		return "album_select";
	}

	override function getMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		var item:AlbumMenuItem;
		for (album in albums)
		{
			item = new AlbumMenuItem(album, {
				onSelected: function() // When an album is selected, the hint should display the credits
				{
					if (album.credits.length <= 0)
					{
						currentHint = null;
						return;
					}

					var hint:String = "Credits:";
					for (credit in album.credits)
						hint += "\n" + credit.name + " - " + credit.role;
					currentHint = hint;
				}
			});
		}
		return items;
	}
}
