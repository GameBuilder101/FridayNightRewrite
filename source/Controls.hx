package;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

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

		// Add volume-related actions
		volumeUp.addTo(input);
		volumeDown.addTo(input);
		mute.addTo(input);

		// Add UI-related actions
		uiLeft.addTo(input);
		uiDown.addTo(input);
		uiUp.addTo(input);
		uiRight.addTo(input);
		accept.addTo(input);
		cancel.addTo(input);

		// Add note-related actions
		noteLeft.addTo(input);
		noteDown.addTo(input);
		noteUp.addTo(input);
		noteRight.addTo(input);

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

	/** Loads the action data from parsed JSON. **/
	public static function loadParsedJSON(parsed:Dynamic) {}
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

	var action:FlxActionDigital;

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

	public inline function addTo(input:FlxActionManager)
	{
		input.addAction(action);
	}
}
