package;

import SoundData;
import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import haxe.CallStack;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import lime.app.Application;
import music.Conductor;
import music.MusicData;
import stage.Stage;

using StringTools;

/** A class to handle HScripts. **/
class Script
{
	var script:String;

	/** The directory used to load/identify the script. **/
	var directory(default, null):String;

	/** The ID used to load/identify the script. **/
	var id(default, null):String;

	var parser:Parser;
	var interp:Interp;

	var started:Bool;

	public function new(script:String, directory:String, id:String)
	{
		this.script = script;
		this.directory = directory;
		this.id = id;
		parser = new Parser();
		parser.allowTypes = true;
		interp = new Interp();
	}

	/** Initializes the script. If not called, this script will not be parsed or executed. **/
	public function start()
	{
		if (started)
			return;
		started = run(script, Registry.getFullPath(directory, id));
		if (!started)
			return;

		// Separated for organization
		setHaxeVars();
		setEngineVars();
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
	public function call(name:String, args:Array<Dynamic> = null)
	{
		// Get the function from the script
		var func:Dynamic = get(name);
		if (func == null || !Reflect.isFunction(func))
			return;

		if (args == null)
			args = [];
		try
		{
			// Call the function
			Reflect.callMethod(this, func, args);
		}
		catch (e:Dynamic)
			error("Could not call function '" + name + "': the number or type of arguments is incorrect");
	}

	/** Triggers an error and displays a warning from this script. **/
	inline function error(message:String)
	{
		trace("Error on script '" + id + "'! " + message);
		Application.current.window.alert(message, "Error on script '" + id + "'!");
	}

	function setHaxeVars()
	{
		set("Date", Date);
		set("DateTools", DateTools);
		set("Math", Math);
		set("Std", Std);
		set("StringTools", StringTools);
		set("Json", haxe.Json);
	}

	function setEngineVars()
	{
		set("FlxBasic", flixel.FlxBasic);
		set("FlxCamera", flixel.FlxCamera);
		set("FlxG", FlxG);
		set("FlxObject", flixel.FlxObject);
		set("FlxSprite", FlxSprite);
		set("FlxState", flixel.FlxState);
		set("FlxSubState", flixel.FlxSubState);
		set("FlxAnimation", flixel.animation.FlxAnimation);
		set("FlxParticle", flixel.effects.particles.FlxParticle);
		set("PostProcess", flixel.effects.postprocess.PostProcess);
		set("FlxGraphic", flixel.graphics.FlxGraphic);
		set("FlxAtlasFrames", flixel.graphics.frames.FlxAtlasFrames);
		set("FlxFrame", flixel.graphics.frames.FlxFrame);
		set("FlxFramesCollection", flixel.graphics.frames.FlxFramesCollection);
		set("FlxImageFrame", flixel.graphics.frames.FlxImageFrame);
		set("FlxAngle", flixel.math.FlxAngle);
		set("FlxMath", flixel.math.FlxMath);
		set("FlxRandom", flixel.math.FlxRandom);
		set("FlxRect", flixel.math.FlxRect);
		set("FlxText", flixel.text.FlxText);
		set("FlxEase", flixel.tweens.FlxEase);
		set("FlxTween", flixel.tweens.FlxTween);
		set("FlxBar", flixel.ui.FlxBar);
		set("FlxSpriteButton", flixel.ui.FlxSpriteButton);
		set("FlxGradient", flixel.util.FlxGradient);
		set("FlxTimer", flixel.util.FlxTimer);
		set("Application", Application);

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

	function setGameVars()
	{
		set("AssetSprite", AssetSprite);
		set("AssetSpriteDataRegistry", AssetSprite.AssetSpriteDataRegistry);
		set("SpriteText", SpriteText);
		set("SoundData", SoundData);
		set("SoundDataRegistry", SoundData.SoundDataRegistry);
		set("MusicData", music.MusicData);
		set("MusicDataRegistry", music.MusicData.MusicDataRegistry);
		set("Conductor", music.Conductor);
		set("Node", music.Node);
		set("Event", music.Event);
		set("ShaderResolver", shader.ShaderResolver);
		set("FileManager", FileManager);
		set("LibraryManager", LibraryManager);
		set("Controls", Controls);
		set("Settings", Settings);
		set("ConductedState", ConductedState);
		set("Menu", menu.Menu);
		set("StageDataRegistry", stage.Stage.StageDataRegistry);
		set("AlbumDataRegistry", Album.AlbumDataRegistry);
		set("WeekDataRegistry", Week.WeekDataRegistry);
		set("SongDataRegistry", Song.SongDataRegistry);

		// Add useful functions

		// Traces and makes a window alert. Useful for debugging
		set("alert", function(message:String)
		{
			trace("Script alert from '" + id + "': " + message);
			Application.current.window.alert(message, "Script alert from '" + id + "'");
		});

		// Makes an asset-sprite and adds it to the current state
		set("addSprite", function(x:Float, y:Float, id:String):AssetSprite
		{
			var sprite:AssetSprite = new AssetSprite(x, y, id);
			FlxG.state.add(sprite);
			return sprite;
		});
		// Makes an asset-sprite and inserts it in the current state
		set("insertSprite", function(position:Int, x:Float, y:Float, id:String):AssetSprite
		{
			var sprite:AssetSprite = new AssetSprite(x, y, id);
			FlxG.state.insert(position, sprite);
			return sprite;
		});

		set("playSound", function(id:String)
		{
			var data:SoundData = SoundDataRegistry.getAsset(id);
			if (data == null)
				return;
			data.play();
		});
		// Plays a sound with the given ID on a sound object
		set("playSoundOn", function(id:String, sound:FlxSound)
		{
			var data:SoundData = SoundDataRegistry.getAsset(id);
			if (data == null)
				return;
			data.playOn(sound);
		});

		set("playMusic", function(id:String, looped:Bool, restart:Bool = true)
		{
			var music:MusicData = MusicDataRegistry.getAsset(id);
			if (music == null)
				return;
			Conductor.play(music, looped, restart);
		});
		set("transitionPlayMusic", function(id:String, looped:Bool, duration:Float, restart:Bool = true)
		{
			var music:MusicData = MusicDataRegistry.getAsset(id);
			if (music == null)
				return;
			Conductor.transitionPlay(music, looped, duration, restart);
		});

		// Loads and replaces the current stage (warning: doing this could cause bugs and be very laggy!)
		set("loadStage", function(id:String)
		{
			cast(FlxG.state, ConductedState).stage.loadFromData(StageDataRegistry.getAsset(id));
		});
		set("getStageElements", getStageElements);
		set("getStageElement", getStageElement);
		// Makes an asset-sprite and inserts it in the current stage
		set("insertSpriteInStage", function(position:Int, x:Float, y:Float, id:String):AssetSprite
		{
			var sprite:AssetSprite = new AssetSprite(x, y, id);
			cast(FlxG.state, ConductedState).stage.insert(position, sprite);
			return sprite;
		});
		// Sets a stage element visible
		set("setVisible", function(targetTag:String, value:Bool)
		{
			for (element in getStageElements(targetTag))
				element.visible = value;
		});
		// Plays an animation on a stage element
		set("playAnim", function(targetTag:String, name:String)
		{
			for (element in getStageElements(targetTag))
			{
				if (element is AssetSprite)
					cast(element, AssetSprite).playAnimation(name, true);
				else
					element.animation.play(name, true);
			}
		});
	}

	/** Gets all stage elements with the given tag. **/
	function getStageElements(targetTag:String):Array<FlxSprite>
	{
		return cast(FlxG.state, ConductedState).stage.getElementsWithTag(targetTag);
	}

	/** Gets a singular stage element with the given tag. **/
	function getStageElement(targetTag:String):FlxSprite
	{
		var elements:Array<FlxSprite> = cast(FlxG.state, ConductedState).stage.getElementsWithTag(targetTag);
		if (elements.length <= 0)
			return null;
		return elements[0];
	}
}

abstract class ScriptRegistry extends Registry<Script>
{
	function loadData(directory:String, id:String):Script
	{
		var script = FileManager.getHScript(Registry.getFullPath(directory, id));
		if (script == null)
			return null;
		return new Script(script, directory, id);
	}
}
