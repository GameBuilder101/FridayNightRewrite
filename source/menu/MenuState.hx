package menu;

import assetManagement.ParsedJSONRegistry;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import menu.Menu;
import menu.MenuItem;
import music.ConductedState;
import music.Conductor;
import music.MusicData;
import stage.Stage;

/** Can be re-used for any menu-based states. **/
abstract class MenuState extends ConductedState
{
	/** The actual menu for this state. May not exist if one could not be found in the stage data. **/
	public var menu(default, null):Menu;

	/** Miscellaneous menu state data obtained from a JSON file. Null if no such file is found. **/
	var data:Dynamic;

	var titleText:FlxText;
	var titleBack:FlxSprite;

	/** The current menu hint text. If null, the hint will not be displayed. **/
	var currentHint:String = null;

	var hintText:FlxText;
	var hintBack:FlxSprite;

	override public function create()
	{
		super.create();

		// Get the primary menu and add the menu options
		var menus:Array<FlxSprite> = stage.getElementsWithTag("menu");
		if (menus.length > 0 && menus[0] is Menu)
		{
			menu = cast menus[0];
			menu.addItems(getMenuItems());
		}

		data = ParsedJSONRegistry.getAsset("menus/" + getMenuID() + "/menu_state_data");
		// Play menu music if it was defined in the JSON
		if (data != null && data.musicID != null)
			Conductor.play(MusicRegistry.getAsset(data.musicID), true, false);

		var title:String = getTitle();
		if (title != null)
		{
			titleBack = new FlxSprite(FlxG.width / 2.0 - FlxG.width / 3.0, 16.0).makeGraphic(cast(FlxG.width / 1.5), 45, FlxColor.BLACK);
			titleBack.alpha = 0.4;
			add(titleBack);
			titleText = new FlxText(titleBack.x + 16.0, titleBack.y, titleBack.width - 32.0, title);
			titleText.setFormat("Jann Script Bold", 24, FlxColor.WHITE, CENTER);
			add(titleText);
		}

		hintBack = new FlxSprite(FlxG.width / 2.0 - FlxG.width / 3.0, FlxG.height - 106.0).makeGraphic(cast(FlxG.width / 1.5), 90, FlxColor.BLACK);
		hintBack.alpha = 0.4;
		hintBack.visible = false;
		add(hintBack);
		hintText = new FlxText(hintBack.x + 16.0, hintBack.y + 16.0, hintBack.width - 32.0, currentHint);
		hintText.setFormat("Jann Script Bold", 17, FlxColor.WHITE, CENTER);
		hintText.visible = false;
		add(hintText);
	}

	function createStage():Stage
	{
		return new Stage("menus/" + getMenuID());
	}

	/** Return the menu ID (IE: "title_screen"). **/
	abstract function getMenuID():String;

	/** Return a list of menu items to add if a menu is found. **/
	function getMenuItems():Array<MenuItem>
	{
		return [];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		hintText.text = currentHint;
		hintText.visible = currentHint != null;
		hintBack.visible = currentHint != null;
	}

	/** Returns the title to display for this menu. If null, a title will not be displayed. **/
	function getTitle():String
	{
		return null;
	}

	/** Plays a delayed transition to the given state and disables the menu. **/
	function specialTransition(state:FlxState)
	{
		if (menu != null)
			menu.interactable = false;
		new FlxTimer().start(0.8, function(timer:FlxTimer)
		{
			FlxG.switchState(state);
		});
	}
}
