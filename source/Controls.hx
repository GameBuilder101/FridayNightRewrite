package;

import flixel.FlxG;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;

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
		input.addActions(cast [volumeUp, volumeDown]);

		mute = new FlxActionDigital("mute");
		input.addAction(cast [mute], 1);

		// UI-related actions
		uiLeft = new FlxActionDigital("ui_left");
		uiDown = new FlxActionDigital("ui_down");
		uiUp = new FlxActionDigital("ui_up");
		uiRight = new FlxActionDigital("ui_right");
		input.addAction(cast [uiLeft, uiDown, uiUp, uiRight]);

		accept = new FlxActionDigital("accept");
		input.addAction(cast [accept]);

		cancel = new FlxActionDigital("cancel");
		input.addAction(cast [cancel]);

		// Gameplay-related actions
		noteLeft = new FlxActionDigital("note_left");
		noteDown = new FlxActionDigital("note_down");
		noteUp = new FlxActionDigital("note_up");
		noteRight = new FlxActionDigital("note_right");
		input.addAction(cast [noteLeft, noteDown, noteUp, noteRight]);

		FlxG.inputs.add(input);
	}

	static function mapDefaultInputs()
	{
		// Volume-related actions
		volumeUp.addKey(PLUS, JUST_PRESSED);
		volumeDown.addKey(MINUS, JUST_PRESSED);

		mute.addKey(ZERO, JUST_PRESSED);

		// UI-related actions
		uiLeft.addKey(LEFT, JUST_PRESSED);
		uiDown.addKey(DOWN, JUST_PRESSED);
		uiUp.addKey(UP, JUST_PRESSED);
		uiRight.addKey(RIGHT, JUST_PRESSED);

		accept.addKey(ENTER, JUST_PRESSED);

		cancel.addKey(ESCAPE, JUST_PRESSED);

		// Gameplay-related actions
		noteLeft.addKey(LEFT, PRESSED);
		noteLeft.addKey(A, PRESSED);
		noteDown.addKey(DOWN, PRESSED);
		noteDown.addKey(S, PRESSED);
		noteUp.addKey(UP, PRESSED);
		noteDown.addKey(W, PRESSED);
		noteRight.addKey(RIGHT, PRESSED);
		noteDown.addKey(D, PRESSED);
	}
}
