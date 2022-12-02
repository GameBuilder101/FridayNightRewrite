package menu;

import assetManagement.ParsedJSONRegistry;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
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

	override public function create()
	{
		super.create();

		// Must be done after FlxG has a chance to initialize or else it throws an error
		Controls.initialize();
		// Must be called somewhere in a state (after initialization), since graphics (such as the transition tile) can't be obtained before then
		TransitionManager.updateDefaultTrans();
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// Get the primary menu and add the menu options
		var menus:Array<FlxSprite> = stage.getElementsWithTag("menu");
		if (menus.length > 0 && menus[0] is Menu)
		{
			menu = cast menus[0];
			menu.createItems(getMenuItems());
		}

		data = ParsedJSONRegistry.getAsset("menus/" + getMenuID() + "/menu_state_data");
		// Play menu music if it was defined in the JSON
		if (data != null && data.musicID != null)
			Conductor.play(MusicRegistry.getAsset(data.musicID), true, false);
	}

	function createStage():Stage
	{
		return new Stage("menus/" + getMenuID());
	}

	/** Return the menu ID (IE: "title_screen"). **/
	abstract function getMenuID():String;

	/** Return a list of menu items to add if a menu is found. **/
	function getMenuItems():Array<MenuItemData>
	{
		return [];
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
