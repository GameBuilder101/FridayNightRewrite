package gbc.scripting;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import haxe.CallStack;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import lime.app.Application;

using StringTools;

/** A class to handle HScripts. **/
class Script
{
	public var script(default, null):String;

	/** Used to identify the script in error messages. **/
	public var name(default, null):String;

	var parser:Parser;
	var interp:Interp;

	public var started(default, null):Bool;

	public function new(script:String, name:String)
	{
		this.script = script;
		this.name = name;
		parser = new Parser();
		parser.allowTypes = true;
		interp = new Interp();
	}

	/** Initializes the script. If not called, this script will not be parsed or executed. **/
	public function start()
	{
		if (started)
			return;
		started = run(script, name);
		if (!started)
			return;

		// Separated for organization
		setHaxeVars();
		setEngineVars();
		setLibraryVars();
		setGameVars();
	}

	/** Attempts to parse and execute a script.
		@return Whether the execution was successful
	**/
	function run(script:String, origin:String = "hscript"):Bool
	{
		// Try to parse the script
		var expr:Expr;
		try
		{
			expr = parser.parseString(script, origin);
		}
		catch (e:Dynamic)
		{
			error(e.line + ": characters " + e.pmin + " - " + e.pmax + ": " + e);
			return false;
		}

		// Try to run the script
		try
		{
			interp.execute(expr);
			return true;
		}
		catch (e:Dynamic)
		{
			error("Could not execute: " + e + CallStack.toString(CallStack.exceptionStack()));
			return false;
		}
	}

	public inline function get(name:String):Dynamic
	{
		return interp.variables.get(name);
	}

	public inline function set(name:String, value:Dynamic)
	{
		interp.variables.set(name, value);
	}

	/** Calls a function in the script. (If it does not exist, this does nothing.) **/
	public function call(name:String, args:Array<Dynamic> = null):Dynamic
	{
		// Get the function from the script
		var func:Dynamic = get(name);
		if (func == null || !Reflect.isFunction(func))
			return null;

		if (args == null)
			args = [];
		try
		{
			// Call the function
			return Reflect.callMethod(this, func, args);
		}
		catch (e:Dynamic)
			error("Could not call function '" + name + "': " + e);
		return null;
	}

	/** Triggers an error and displays a warning from this script. **/
	inline function error(message:String)
	{
		trace("Error on script '" + name + "'! " + message);
		Application.current.window.alert(message, "Error on script '" + name + "'!");
	}

	/** Set any Haxe-related variables that the script can use. **/
	function setHaxeVars()
	{
		set("Math", Math);
		set("Std", Std);
		set("Json", haxe.Json);
	}

	/** Set any engine-related variables that the script can use. **/
	function setEngineVars()
	{
		set("FlxG", FlxG);
		set("FlxObject", flixel.FlxObject);
		set("FlxSprite", FlxSprite);
		set("FlxAnimation", flixel.animation.FlxAnimation);
		set("FlxGraphic", flixel.graphics.FlxGraphic);
		set("FlxAngle", flixel.math.FlxAngle);
		set("FlxMath", flixel.math.FlxMath);
		set("FlxRect", flixel.math.FlxRect);
		set("FlxText", flixel.text.FlxText);
		set("FlxTextBorderStyle", flixel.text.FlxText.FlxTextBorderStyle);
		set("FlxEase", flixel.tweens.FlxEase);
		set("FlxTween", flixel.tweens.FlxTween);
		set("FlxGradient", flixel.util.FlxGradient);
		set("FlxTimer", flixel.util.FlxTimer);

		// Add useful functions

		// Returns a color
		set("colorRGB", function(r:Int, g:Int, b:Int, a:Int = 255):FlxColor
		{
			return FlxColor.fromRGB(r, g, b, a);
		});
		// Returns a color
		set("colorRGBFloat", function(r:Float, g:Float, b:Float, a:Float = 1.0):FlxColor
		{
			return FlxColor.fromRGBFloat(r, g, b, a);
		});
		// Returns a color (str should be something like a hex code)
		set("colorString", function(str:String):FlxColor
		{
			return FlxColor.fromString(str);
		});
		// Returns a color
		set("colorInterpolate", function(color1:FlxColor, color2:FlxColor, factor:Float = 0.5):FlxColor
		{
			return FlxColor.interpolate(color1, color2, factor);
		});
	}

	/** Set any library-related variables that the script can use. **/
	function setLibraryVars()
	{
		set("Script", Script);
		set("Point", Point);
		set("LibraryManager", gbc.assets.LibraryManager);
		set("AssetSprite", gbc.graphics.AssetSprite);
		set("AssetSpriteRegistry", gbc.graphics.AssetSpriteRegistry);
		set("TransitionDataRegistry", gbc.graphics.TransitionDataRegistry);
		set("AssetMusic", gbc.sound.AssetMusic);
		set("AssetMusicRegistry", gbc.sound.AssetMusicRegistry);
		set("MusicManager", gbc.sound.MusicManager);
		set("AssetSound", gbc.sound.AssetSound);
		set("AssetSoundRegistry", gbc.sound.AssetSoundRegistry);
	}

	/** Set any game-specific-related variables that the script can use. **/
	function setGameVars() {}
}
