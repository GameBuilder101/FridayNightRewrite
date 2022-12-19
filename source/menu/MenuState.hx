package menu;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
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

	/** The current menu title text. If null, the hint will not be displayed. **/
	var currentTitle:String = null;

	var titleText:FlxText;
	var titleBack:FlxSprite;

	/** The current menu hint text. If null, the hint will not be displayed. **/
	var currentHint:String = null;

	var hintText:FlxText;
	var hintBack:FlxSprite;

	override function create()
	{
		super.create();

		// Get the primary menu and add the menu options
		var menus:Array<FlxSprite> = stage.getElementsWithTag("menu");
		if (menus.length > 0 && menus[0] is Menu)
		{
			menu = cast menus[0];
			menu.addItems(getMenuItems());
		}

		data = MenuStateDataRegistry.getAsset("menus/" + getMenuID());
		if (data == null)
			data = {};

		// Play menu music if it was defined in the JSON
		if (data.musicID != null)
			Conductor.play(MusicDataRegistry.getAsset(data.musicID), true, false);

		titleBack = new FlxSprite(FlxG.width / 2.0 - FlxG.width / 3.0, 16.0).makeGraphic(cast(FlxG.width / 1.5), 45, FlxColor.BLACK);
		titleBack.alpha = 0.4;
		add(titleBack);
		titleText = new FlxText(titleBack.x + 16.0, titleBack.y, titleBack.width - 32.0, currentTitle);
		titleText.setFormat("Jann Script Bold", 24, FlxColor.WHITE, CENTER);
		add(titleText);

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

		titleText.text = currentTitle;
		titleText.visible = currentTitle != null;
		titleBack.visible = currentTitle != null;

		hintText.text = currentHint;
		hintText.visible = currentHint != null;
		hintBack.visible = currentHint != null;
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

class MenuStateDataRegistry extends Registry<Dynamic>
{
	static var cache:MenuStateDataRegistry = new MenuStateDataRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
		});
	}

	function loadData(directory:String, id:String):Dynamic
	{
		return FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/menu_state_data");
	}

	public static function getAsset(id:String):Dynamic
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
