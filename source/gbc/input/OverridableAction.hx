package gbc.input;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

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
	public function check():Bool
	{
		return action.check();
	}

	public function getKeyDisplayName(index:Int):String
	{
		return getKeyBind(index);
	}

	public function getGamepadDisplayName(index:Int):String
	{
		return getGamepadBind(index);
	}

	/** Returns either the key or gamepad display name at bind index, depending on if a gamepad is plugged in. **/
	public function getDisplayName(index:Int):String
	{
		return FlxG.gamepads.numActiveGamepads > 0 ? getGamepadDisplayName(index) : getKeyDisplayName(index);
	}

	/** Converts the action to be savable dynamic for a saver. **/
	public function toSave():Dynamic
	{
		var data:Dynamic = {
			overrideKeyBinds: new Array<String>(),
			overrideGamepadBinds: new Array<String>()
		};
		for (bind in overrideKeyBinds)
			data.overrideKeyBinds.push(bind.toString());
		for (bind in overrideGamepadBinds)
			data.overrideGamepadBinds.push(bind.toString());
		return data;
	}

	/** Loads the action from a savable dynamic from a saver. **/
	public function loadSave(data:Dynamic)
	{
		if (data == null)
			return;
		resetOverrides();
		var i:Int = 0;
		for (bind in cast(data.overrideKeyBinds, Array<Dynamic>))
		{
			overrideKey(i, FlxKey.fromString(bind));
			i++;
		}
		i = 0;
		for (bind in cast(data.overrideGamepadBinds, Array<Dynamic>))
		{
			overrideGamepad(i, FlxGamepadInputID.fromString(bind));
			i++;
		}
	}
}
