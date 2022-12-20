package;

import Saver;
import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

/** Used to access and manage game-specific controls. A big and ugly class with lots of hard-coded action data. **/
class Controls extends Saver
{
	public static var instance(default, null):Controls;
	static var initialized:Bool;

	// Volume actions
	public static var volumeUp:OverridableAction = new OverridableAction("volumeUp", "Volume Up", JUST_PRESSED, 1, [PLUS], []);
	public static var volumeDown:OverridableAction = new OverridableAction("volumeDown", "Volume Down", JUST_PRESSED, 1, [MINUS], []);
	public static var mute:OverridableAction = new OverridableAction("mute", "Mute", JUST_PRESSED, 1, [ZERO], []);

	// UI actions
	public static var uiLeft:OverridableAction = new OverridableAction("uiLeft", "UI Left", JUST_PRESSED, 2, [LEFT, A],
		[LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT]);
	public static var uiDown:OverridableAction = new OverridableAction("uiDown", "UI Down", JUST_PRESSED, 2, [DOWN, S],
		[LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN]);
	public static var uiUp:OverridableAction = new OverridableAction("uiUp", "UI Up", JUST_PRESSED, 2, [UP, W],
		[LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP]);
	public static var uiRight:OverridableAction = new OverridableAction("uiRight", "UI Right", JUST_PRESSED, 2, [RIGHT, D],
		[LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT]);
	public static var accept:OverridableAction = new OverridableAction("accept", "Accept", JUST_PRESSED, 1, [ENTER], [A]);
	public static var cancel:OverridableAction = new OverridableAction("cancel", "Cancel", JUST_PRESSED, 1, [ESCAPE], [B]);

	// Note actions
	public static var noteLeft:OverridableAction = new OverridableAction("noteLeft", "Note Left", PRESSED, 2, [LEFT, A],
		[LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT]);
	public static var noteDown:OverridableAction = new OverridableAction("noteDown", "Note Down", PRESSED, 2, [DOWN, S],
		[LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN]);
	public static var noteUp:OverridableAction = new OverridableAction("noteUp", "Note Up", PRESSED, 2, [UP, W],
		[LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP]);
	public static var noteRight:OverridableAction = new OverridableAction("noteRight", "Note Right", PRESSED, 2, [RIGHT, D],
		[LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT]);

	static var input:FlxActionManager;

	/** Must be done after FlxG has a chance to initialize or else this throws an error. **/
	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;
		instance = new Controls();

		// Volume-changing input is handled manually
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.muteKeys = null;
	}

	public function new()
	{
		input = new FlxActionManager();

		// Volume actions
		input.addSet(new FlxActionSet("volume", [volumeUp.action, volumeDown.action]));
		input.addSet(new FlxActionSet("mute", [mute.action]));

		// UI actions
		input.addSet(new FlxActionSet("ui", [uiLeft.action, uiDown.action, uiUp.action, uiRight.action]));
		input.addSet(new FlxActionSet("accept", [accept.action]));
		input.addSet(new FlxActionSet("cancel", [cancel.action]));

		// Note actions
		input.addSet(new FlxActionSet("note", [noteLeft.action, noteDown.action, noteUp.action, noteRight.action]));

		FlxG.inputs.add(input);

		super();
	}

	function getSaverID():String
	{
		return "controls";
	}

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():Map<String, Dynamic>
	{
		return new Map<String, Dynamic>();
	}

	override function save()
	{
		// Volume actions
		volumeUp.saveTo(data);
		volumeDown.saveTo(data);
		mute.saveTo(data);

		// UI actions
		uiLeft.saveTo(data);
		uiDown.saveTo(data);
		uiUp.saveTo(data);
		uiRight.saveTo(data);
		accept.saveTo(data);
		cancel.saveTo(data);

		// Note actions
		noteLeft.saveTo(data);
		noteDown.saveTo(data);
		noteUp.saveTo(data);
		noteRight.saveTo(data);

		super.save();
	}

	override function load()
	{
		super.load();

		// Volume actions
		volumeUp.loadFrom(data);
		volumeDown.loadFrom(data);
		mute.loadFrom(data);

		// UI actions
		uiLeft.loadFrom(data);
		uiDown.loadFrom(data);
		uiUp.loadFrom(data);
		uiRight.loadFrom(data);
		accept.loadFrom(data);
		cancel.loadFrom(data);

		// Note actions
		noteLeft.loadFrom(data);
		noteDown.loadFrom(data);
		noteUp.loadFrom(data);
		noteRight.loadFrom(data);
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
}

/** A wrapper to help simplify action management and adding binding overrides. **/
class OverridableAction
{
	public var name(default, null):String;
	public var displayName(default, null):String;
	public var state(default, null):FlxInputState;

	/** How many binds can this action can contain. **/
	public var maxBinds(default, null):Int;

	public var defaultKeyBinds(default, null):Array<FlxKey>;
	public var defaultGamepadBinds(default, null):Array<FlxGamepadInputID>;

	var overrideKeyBinds:Array<FlxKey> = [];
	var overrideGamepadBinds:Array<FlxGamepadInputID> = [];

	public var action(default, null):FlxActionDigital;

	public function new(name:String, displayName:String, state:FlxInputState, maxBinds:Int, defaultKeyBinds:Array<FlxKey>,
			defaultGamepadBinds:Array<FlxGamepadInputID>)
	{
		this.name = name;
		this.displayName = displayName;
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

	public function saveTo(data:Map<String, Dynamic>)
	{
		var value:Dynamic = {};

		value.overrideKeyBinds = new Array<String>();
		for (bind in overrideKeyBinds)
			value.overrideKeyBinds.push(bind.toString());

		value.overrideGamepadBinds = new Array<String>();
		for (bind in overrideGamepadBinds)
			value.overrideGamepadBinds.push(bind.toString());

		data.set(name, value);
	}

	public function loadFrom(data:Map<String, Dynamic>)
	{
		// If there is no data for this action, just return
		if (!data.exists(name))
			return;
		var value:Dynamic = data[name];

		var i:Int = 0;
		for (bind in cast(value.overrideKeyBinds, Array<Dynamic>))
		{
			overrideKey(i, FlxKey.fromString(bind));
			i++;
		}

		i = 0;
		for (bind in cast(value.overrideGamepadBinds, Array<Dynamic>))
		{
			overrideGamepad(i, FlxGamepadInputID.fromString(bind));
			i++;
		}
	}
}
