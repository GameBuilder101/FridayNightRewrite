package menu;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Menu extends FlxSpriteGroup
{
	/** The type of menu. **/
	public var menuType(default, null):MenuType;

	/** The normal menu item color. **/
	public var normalItemColor:FlxColor;

	/** The selected menu item color. **/
	public var selectedItemColor:FlxColor;
}

enum MenuType
{
	RADIAL;
	LIST;
	LIST_DIAGONAL;
	LIST_HORIZONTAL;
}
