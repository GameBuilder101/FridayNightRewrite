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
import music.Conductor;
import music.EventChart;
import music.MusicData;
import stage.Stage;

/** Can be re-used for any menu-based states. **/
abstract class MenuState extends ConductedState
{
	/** The actual menu for this state. May not exist if one could not be found in the stage data. **/
	public var menu(default, null):Menu;

	/** The background for this state. May not exist if one could not be found in the stage data. **/
	public var background(default, null):AssetSprite;

	/** Miscellaneous menu state data obtained from a JSON file. Null if no such file is found. **/
	var data:Dynamic;

	/** The current menu title text. If null, the hint will not be displayed. **/
	public var currentTitle(default, null):String = null;

	var titleText:FlxText;
	var titleBack:FlxSprite;

	/** The current menu hint text. If null, the hint will not be displayed. **/
	public var currentHint(default, null):String = null;

	var hintText:FlxText;
	var hintBack:FlxSprite;

	override function create()
	{
		super.create();

		// Get the menu element to use with this menu
		menu = cast stage.getElementWithTag("menu");

		// Get the primary background
		background = cast stage.getElementWithTag("menu_background");

		data = MenuStateDataRegistry.getAsset("menus/" + getMenuID());
		if (data == null)
			data = {};

		// Play menu music if it was defined in the JSON
		if (data.musicID != null)
			Conductor.play(MusicDataRegistry.getAsset(data.musicID), true, false);
		// Load an event chart if it was defined in the JSON
		if (data.eventChartID != null)
			eventChart = EventChartRegistry.getAsset(data.eventChartID);

		titleBack = new FlxSprite(FlxG.width / 2.0 - FlxG.width / 3.0, 16.0).makeGraphic(cast(FlxG.width / 1.5), 45, FlxColor.BLACK);
		titleBack.alpha = 0.4;
		add(titleBack);
		titleText = new FlxText(titleBack.x + 16.0, titleBack.y, titleBack.width - 32.0, currentTitle);
		titleText.setFormat("Jann Script Bold", 24, FlxColor.WHITE, CENTER);
		add(titleText);

		hintBack = new FlxSprite(FlxG.width / 2.0 - FlxG.width / 3.0, FlxG.height - 116.0).makeGraphic(cast(FlxG.width / 1.5), 100, FlxColor.BLACK);
		hintBack.alpha = 0.4;
		hintBack.visible = false;
		add(hintBack);
		hintText = new FlxText(hintBack.x + 16.0, hintBack.y + 16.0, hintBack.width - 32.0, currentHint);
		hintText.setFormat("Jann Script Bold", 19, FlxColor.WHITE, CENTER);
		hintText.visible = false;
		add(hintText);
	}

	function createStage():Stage
	{
		return new Stage("menus/" + getMenuID());
	}

	/** Return the menu ID (IE: "title_screen"). **/
	abstract function getMenuID():String;

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
