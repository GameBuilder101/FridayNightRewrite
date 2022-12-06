package;

import assetManagement.FileManager;
import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import sys.io.File;

/** Used to access and manage game-specific controls. A big and ugly class with lots of hard-coded action data. **/
class Controls
{
	// Volume-related actions
	public static var volumeUp:OverridableAction = new OverridableAction("volume_up", JUST_PRESSED, 1, [PLUS], []);
	public static var volumeDown:OverridableAction = new OverridableAction("volume_down", JUST_PRESSED, 1, [MINUS], []);
	public static var mute:OverridableAction = new OverridableAction("mute", JUST_PRESSED, 1, [ZERO], []);

	// UI-related actions
	public static var uiLeft:OverridableAction = new OverridableAction("ui_left", JUST_PRESSED, 2, [LEFT, A],
		[LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT]);
	public static var uiDown:OverridableAction = new OverridableAction("ui_down", JUST_PRESSED, 2, [DOWN, S],
		[LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN]);
	public static var uiUp:OverridableAction = new OverridableAction("ui_up", JUST_PRESSED, 2, [UP, W], [LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP]);
	public static var uiRight:OverridableAction = new OverridableAction("ui_right", JUST_PRESSED, 2, [RIGHT, D],
		[LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT]);
	public static var accept:OverridableAction = new OverridableAction("accept", JUST_PRESSED, 1, [ENTER], [A]);
	public static var cancel:OverridableAction = new OverridableAction("cancel", JUST_PRESSED, 1, [ESCAPE], [B]);

	// Note-related actions
	public static var noteLeft:OverridableAction = new OverridableAction("note_left", PRESSED, 2, [LEFT, A],
		[LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT]);
	public static var noteDown:OverridableAction = new OverridableAction("note_down", PRESSED, 2, [DOWN, S],
		[LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN]);
	public static var noteUp:OverridableAction = new OverridableAction("note_up", PRESSED, 2, [UP, W], [LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP]);
	public static var noteRight:OverridableAction = new OverridableAction("note_right", PRESSED, 2, [RIGHT, D],
		[LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT]);

	static var initialized:Bool;
	static var input:FlxActionManager;

	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;
		input = new FlxActionManager();

		// Volume-related actions
		input.addSet(new FlxActionSet("volume", [volumeUp.action, volumeDown.action]));
		input.addSet(new FlxActionSet("mute", [mute.action]));

		// UI-related actions
		input.addSet(new FlxActionSet("ui", [uiLeft.action, uiDown.action, uiUp.action, uiRight.action]));
		input.addSet(new FlxActionSet("accept", [accept.action]));
		input.addSet(new FlxActionSet("cancel", [cancel.action]));

		// Note-related actions
		input.addSet(new FlxActionSet("note", [noteLeft.action, noteDown.action, noteUp.action, noteRight.action]));

		// Load from the controls data
		var parsed:Dynamic = FileManager.getParsedJson("controls");
		if (parsed != null)
			loadParsedJSON(parsed);

		FlxG.inputs.add(input);

		// Volume-changing input is handled manually
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.muteKeys = null;
	}

	/** Updates the volume/mute actions. **/
	public static function updateSoundActions()
	{
		if (volumeUp.check())
			FlxG.sound.changeVolume(0.1);
		if (volumeDown.check())
			FlxG.sound.changeVolume(-0.1);
		if (mute.check())
			FlxG.sound.toggleMuted();
	}

	/** Converts the action data overrides to a Dynamic which can be used for JSON. **/
	public static function toStringifiableJSON():Dynamic
	{
		var stringifiable:Dynamic = {};

		// Volume-related actions
		stringifiable.volumeUp = volumeUp.toStringifiableJSON();
		stringifiable.volumeDown = volumeDown.toStringifiableJSON();
		stringifiable.mute = mute.toStringifiableJSON();

		// UI-related actions
		stringifiable.uiLeft = uiLeft.toStringifiableJSON();
		stringifiable.uiDown = uiDown.toStringifiableJSON();
		stringifiable.uiUp = uiUp.toStringifiableJSON();
		stringifiable.uiRight = uiRight.toStringifiableJSON();
		stringifiable.accept = accept.toStringifiableJSON();
		stringifiable.cancel = cancel.toStringifiableJSON();

		// Note-related actions
		stringifiable.noteLeft = noteLeft.toStringifiableJSON();
		stringifiable.noteDown = noteDown.toStringifiableJSON();
		stringifiable.noteUp = noteUp.toStringifiableJSON();
		stringifiable.noteRight = noteRight.toStringifiableJSON();

		return stringifiable;
	}

	/** Loads the action data overrides from parsed JSON. **/
	public static function loadParsedJSON(parsed:Dynamic)
	{
		// Volume-related actions
		volumeUp.loadParsedJSON(parsed.volumeUp);
		volumeDown.loadParsedJSON(parsed.volumeDown);
		mute.loadParsedJSON(parsed.mute);

		// UI-related actions
		uiLeft.loadParsedJSON(parsed.uiLeft);
		uiDown.loadParsedJSON(parsed.uiDown);
		uiUp.loadParsedJSON(parsed.uiUp);
		uiRight.loadParsedJSON(parsed.uiRight);
		accept.loadParsedJSON(parsed.accept);
		cancel.loadParsedJSON(parsed.cancel);

		// Note-related actions
		noteLeft.loadParsedJSON(parsed.noteLeft);
		noteDown.loadParsedJSON(parsed.noteDown);
		noteUp.loadParsedJSON(parsed.noteUp);
		noteRight.loadParsedJSON(parsed.noteRight);
	}

	/** Saves the controls to a JSON which can be loaded when starting up the game. **/
	public static function saveToJSON()
	{
		var json:String = Json.stringify(toStringifiableJSON());
		File.write("controls.json").writeString(json);
	}
}

/** A wrapper to help simplify action management and adding binding overrides. **/
class OverridableAction
{
	public var name(default, null):String;
	public var state(default, null):FlxInputState;

	/** How many binds can this action can contain. **/
	public var maxBinds(default, null):Int;

	public var defaultKeyBinds(default, null):Array<FlxKey>;
	public var defaultGamepadBinds(default, null):Array<FlxGamepadInputID>;

	var overrideKeyBinds:Array<FlxKey> = new Array<FlxKey>();
	var overrideGamepadBinds:Array<FlxGamepadInputID> = new Array<FlxGamepadInputID>();

	public var action(default, null):FlxActionDigital;

	public function new(name:String, state:FlxInputState, maxBinds:Int, defaultKeyBinds:Array<FlxKey>, defaultGamepadBinds:Array<FlxGamepadInputID>)
	{
		this.name = name;
		this.state = state;
		this.maxBinds = maxBinds;

		this.defaultKeyBinds = defaultKeyBinds;
		// Make sure the bind arrays are always both at the max length
		while (defaultKeyBinds.length < maxBinds)
			defaultKeyBinds.push(NONE);
		while (overrideKeyBinds.length < maxBinds)
			overrideKeyBinds.push(NONE);

		this.defaultGamepadBinds = defaultGamepadBinds;
		// Make sure the bind arrays are always both at the max length
		while (defaultGamepadBinds.length < maxBinds)
			defaultGamepadBinds.push(NONE);
		while (overrideGamepadBinds.length < maxBinds)
			overrideGamepadBinds.push(NONE);

		action = new FlxActionDigital(name);
		updateAction();
	}

	/** Returns the current binding for the input at index. **/
	public function getKeyBind(index:Int)
	{
		if (overrideKeyBinds[index] != NONE)
			return overrideKeyBinds[index];
		return defaultKeyBinds[index];
	}

	/** Returns the current binding for the input at index. **/
	public function getGamepadBind(index:Int)
	{
		if (overrideGamepadBinds[index] != NONE)
			return overrideGamepadBinds[index];
		return defaultGamepadBinds[index];
	}

	public function overrideKey(index:Int, bind:FlxKey)
	{
		overrideKeyBinds[index] = bind;
		updateAction();
	}

	public function overrideGamepad(index:Int, bind:FlxGamepadInputID)
	{
		overrideGamepadBinds[index] = bind;
		updateAction();
	}

	public function resetOverrides()
	{
		for (i in 0...maxBinds)
		{
			overrideKeyBinds[i] = NONE;
			overrideGamepadBinds[i] = NONE;
		}
		updateAction();
	}

	/** Updates the action inputs using the current bindings. **/
	function updateAction()
	{
		action.removeAll();

		var keyBind:FlxKey;
		var gamepadBind:FlxGamepadInputID;
		for (i in 0...maxBinds)
		{
			keyBind = getKeyBind(i);
			if (keyBind != NONE)
				action.addKey(keyBind, state);

			gamepadBind = getGamepadBind(i);
			if (gamepadBind != NONE)
				action.addGamepad(gamepadBind, state);
		}
	}

	/** Returns true if the action is triggered. **/
	public inline function check():Bool
	{
		return action.check();
	}

	public function toStringifiableJSON():Dynamic
	{
		var stringifiable:Dynamic = {};

		stringifiable.overrideKeyBinds = new Array<String>();
		for (bind in overrideKeyBinds)
			stringifiable.overrideKeyBinds.push(bind.toString());

		stringifiable.overrideGamepadBinds = new Array<String>();
		for (bind in overrideGamepadBinds)
			stringifiable.overrideGamepadBinds.push(bind.toString());

		return stringifiable;
	}

	public function loadParsedJSON(parsed:Dynamic)
	{
		var i:Int = 0;
		for (bind in cast(parsed.overrideKeyBinds, Array<Dynamic>))
		{
			overrideKey(i, FlxKey.fromString(bind));
			i++;
		}

		i = 0;
		for (bind in cast(parsed.overrideGamepadBinds, Array<Dynamic>))
		{
			overrideGamepad(i, FlxGamepadInputID.fromString(bind));
			i++;
		}
	}
}
