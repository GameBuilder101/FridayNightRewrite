package;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.input.actions.FlxActionInput;
import flixel.FlxG;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;

/** Used to access and manage game-specific controls. **/
class Controls
{
	public static var volumeUp:FlxActionDigital;
	public static var volumeDown:FlxActionDigital;
	public static var mute:FlxActionDigital;

	public static var uiLeft:FlxActionDigital;
	public static var uiDown:FlxActionDigital;
	public static var uiUp:FlxActionDigital;
	public static var uiRight:FlxActionDigital;
	public static var accept:FlxActionDigital;
	public static var cancel:FlxActionDigital;

	public static var noteLeft:FlxActionDigital;
	public static var noteDown:FlxActionDigital;
	public static var noteUp:FlxActionDigital;
	public static var noteRight:FlxActionDigital;

	static var initialized:Bool;
	static var input:FlxActionManager;

	public static function initialize()
	{
		if (initialized)
			return;
		initialized = true;

		createInput();
		mapDefaultInputs();
	}

	/** Creates all actions and adds them to the action manager. **/
	static function createInput()
	{
		input = new FlxActionManager();

		// Volume-related actions
		volumeUp = new FlxActionDigital("volume_up");
		volumeDown = new FlxActionDigital("volume_down");
		input.addSet(new FlxActionSet("volume", [volumeUp, volumeDown]));

		mute = new FlxActionDigital("mute");
		input.addSet(new FlxActionSet("mute", [mute]));

		// UI-related actions
		uiLeft = new FlxActionDigital("ui_left");
		uiDown = new FlxActionDigital("ui_down");
		uiUp = new FlxActionDigital("ui_up");
		uiRight = new FlxActionDigital("ui_right");
		input.addSet(new FlxActionSet("ui", [uiLeft, uiDown, uiUp, uiRight]));

		accept = new FlxActionDigital("accept");
		input.addSet(new FlxActionSet("accept", [accept]));

		cancel = new FlxActionDigital("cancel");
		input.addSet(new FlxActionSet("cancel", [cancel]));

		// Gameplay-related actions
		noteLeft = new FlxActionDigital("note_left");
		noteDown = new FlxActionDigital("note_down");
		noteUp = new FlxActionDigital("note_up");
		noteRight = new FlxActionDigital("note_right");
		input.addSet(new FlxActionSet("note", [noteLeft, noteDown, noteUp, noteRight]));

		FlxG.inputs.add(input);
		// Volume-changing input is handled manually
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.muteKeys = null;
	}

	static function mapDefaultInputs()
	{
		// Volume-related actions
		volumeUp.addKey(PLUS, JUST_PRESSED);

		volumeDown.addKey(MINUS, JUST_PRESSED);

		mute.addKey(ZERO, JUST_PRESSED);

		// UI-related actions
		uiLeft.addKey(LEFT, JUST_PRESSED);
		uiLeft.addGamepad(LEFT_STICK_DIGITAL_LEFT, JUST_PRESSED);

		uiDown.addKey(DOWN, JUST_PRESSED);
		uiDown.addGamepad(LEFT_STICK_DIGITAL_DOWN, JUST_PRESSED);

		uiUp.addKey(UP, JUST_PRESSED);
		uiUp.addGamepad(LEFT_STICK_DIGITAL_UP, JUST_PRESSED);

		uiRight.addKey(RIGHT, JUST_PRESSED);
		uiRight.addGamepad(LEFT_STICK_DIGITAL_RIGHT, JUST_PRESSED);

		accept.addKey(ENTER, JUST_PRESSED);
		accept.addGamepad(A, JUST_PRESSED);

		cancel.addKey(ESCAPE, JUST_PRESSED);
		accept.addGamepad(B, JUST_PRESSED);

		// Gameplay-related actions
		noteLeft.addKey(LEFT, PRESSED);
		noteLeft.addKey(A, PRESSED);
		noteLeft.addGamepad(LEFT_STICK_DIGITAL_LEFT, PRESSED);
		noteLeft.addGamepad(RIGHT_STICK_DIGITAL_LEFT, PRESSED);

		noteDown.addKey(DOWN, PRESSED);
		noteDown.addKey(S, PRESSED);
		noteDown.addGamepad(LEFT_STICK_DIGITAL_DOWN, PRESSED);
		noteDown.addGamepad(RIGHT_STICK_DIGITAL_DOWN, PRESSED);

		noteUp.addKey(UP, PRESSED);
		noteUp.addKey(W, PRESSED);
		noteUp.addGamepad(LEFT_STICK_DIGITAL_UP, PRESSED);
		noteUp.addGamepad(RIGHT_STICK_DIGITAL_UP, PRESSED);

		noteRight.addKey(RIGHT, PRESSED);
		noteRight.addKey(D, PRESSED);
		noteRight.addGamepad(LEFT_STICK_DIGITAL_RIGHT, PRESSED);
		noteRight.addGamepad(RIGHT_STICK_DIGITAL_RIGHT, PRESSED);
	}

	/** Updates the volume/mute actions. **/
	public static function updateSoundActions()
	{
		if (volumeUp.check())
			FlxG.sound.changeVolume(0.125);
		if (volumeDown.check())
			FlxG.sound.changeVolume(-0.125);
		if (mute.check())
			FlxG.sound.toggleMuted();
	}
}

class OverridableAction
{
	public var name(default, null):String;
	public var defaultKeyBinds(default, null):Array<FlxKey>;
	public var defaultGamepadBinds(default, null):Array<FlxGamepadInputID>;

	var overrideKeyBinds:Array<FlxKey>;
	var overrideGamepadBinds:Array<FlxGamepadInputID>;

	var action:FlxAction;

	public function new(name:String, type:FlxInputType, defaultKeyBinds:Array<FlxKey>, defaultGamepadBinds:Array<FlxGamepadInputID>)
	{
		if (type == ANALOG)
			action = new FlxActionAnalog(name);
		else
			action = new FlxActionDigital(name);

		this.name = name;
		this.defaultKeyBinds = defaultKeyBinds;
		this.defaultGamepadBinds = defaultGamepadBinds;
	}
}
