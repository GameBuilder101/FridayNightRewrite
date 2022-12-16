package script;

import assetManagement.LibraryManager;
import flixel.FlxG;
import lime.app.Application;
import llua.Convert;
import llua.Lua;
import llua.LuaL;
import llua.State;

using StringTools;

// Some snippets of code were taken from Psych Engine! https://github.com/ShadowMario/FNF-PsychEngine

/** A class for any general type of LUA script. **/
class LUAScript
{
	/** The "memory" is used as an interface for LUA to store references to objects found or made earlier.
		It can be accessed using "MEMORY" when targeting an object in the LUA script.
	**/
	var memory:Dynamic = {};

	/** The path the LUA script was loaded from (excluding file extension). **/
	var path:String;

	var lua:State;

	/** @param path The path excluding the file extension. **/
	public function new(path:String)
	{
		this.path = path;
		// Initialize the LUA stuff
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

		// Attempt to load the LUA script
		var error:String = "Could not load the script: ";
		try
		{
			// Load the script and get the result value
			var result:Null<Int> = LuaL.dofile(lua, path + ".lua");
			// If the result is not 0, then something went wrong during the process
			if (result != 0)
			{
				luaError(error + Lua.tostring(lua, result));
				return;
			}
		}
		catch (e:Dynamic)
		{
			luaError(error + e);
			return;
		}

		initVariables();
		initCallbacks();

		callLUAFunction("onCreate", []);
	}

	/** Returns true if the script is loaded and active. **/
	public inline function getIsValid():Bool
	{
		return lua != null;
	}

	/** Call this when something goes wrong and we need to stop the script. **/
	function luaError(error:String)
	{
		trace("LUA error on script '" + path + "': " + error);
		// Display the message using a window in case this is not a debug build
		Application.current.window.alert(error, "LUA error on script '" + path + "'!");

		// Stop the script
		lua = null;
	}

	/** Sets the variable on the LUA script. **/
	public function setLUAVariable(name:String, value:Dynamic)
	{
		if (!getIsValid())
			return;
		Convert.toLua(lua, value);
		Lua.setglobal(lua, name);
	}

	/** Adds a callback to the LUA script. **/
	public function addLUACallback(name:String, f:Dynamic)
	{
		if (!getIsValid())
			return;
		Lua_helper.add_callback(lua, name, f);
	}

	/** Calls a function defined in the LUA script. **/
	public function callLUAFunction(name:String, args:Array<Dynamic>)
	{
		if (!getIsValid())
			return;

		try
		{
			// Get the thing from the LUA
			Lua.getglobal(lua, name);

			// If the thing was not a function, don't try to call it
			var type:Int = Lua.type(lua, -1);
			if (type != Lua.LUA_TFUNCTION)
				return;

			// Convert arguments into LUA
			for (arg in args)
				Convert.toLua(lua, arg);

			// Call the function
			var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
		}
		catch (e:Dynamic)
			luaError("Could not call LUA function '" + name + "': " + e);
	}

	/** Since LUA can't interact directly with Haxe objects/types, this is used to target a specific object using a string.
		@param objectName A path of properties broken down using . as the delimiter. Use certain names at the start (IE: "MEMORY")
		to define the initial/source target.
	**/
	function toTargetObject(objectName:String):Dynamic
	{
		var path:Array<String> = objectName.split(".");
		// Get the initial target
		var target:Dynamic = initialTargetObject(path[0]);
		if (target == null)
		{
			luaError("An initial object target was not specified");
			return null;
		}

		// Go down the hierarchy to obtain the target
		for (name in path)
			target = Reflect.getProperty(target, name);
		return target;
	}

	/** Returns an object to use as the initial target in toTargetObject(). Override to add more. **/
	function initialTargetObject(name:String):Dynamic
	{
		// Since this is a more general script class, don't add specific things like stages or characters here!
		switch (name)
		{
			case "MEMORY":
				return memory;
			case "APPLICATION":
				return Application.current;
			case "GAME":
				return FlxG.game;
			case "STATE":
				return FlxG.state;
			case "CONTROLS":
				return Controls.instance;
			case "SETTINGS":
				return Settings.instance;
			default:
				return null;
		}
	}

	/** Converts from an array of LUA arguments to proper arguments. If a string starts with "ENUM:", it is converted to
		an enum instead of being kept a string. If a string starts with "OBJECT:", it is treated as the name of an
		object and is converted using toTargetObject().
	**/
	function convertArgsFromLUA(args:Array<Dynamic>):Array<Dynamic>
	{
		var newArgs:Array<Dynamic> = new Array<Dynamic>();
		var stringArg:String;
		for (arg in args)
		{
			if (!(arg is String)) // Only strings are used for special-case stuff
			{
				newArgs.push(arg);
				continue;
			}
			stringArg = cast arg;

			if (stringArg.startsWith("ENUM:"))
			{
				stringArg = stringArg.substring(6); // Remove "ENUM:" from the front

				// Seperate out the enum name and enum value name
				var splitName:Array<String> = stringArg.split(".");
				var enumName:String = "";
				var enumValueName:String = "";
				var i:Int = 0;
				for (name in splitName)
				{
					if (i >= splitName.length - 1)
						enumValueName = name;
					else
						enumName += name;
					i++;
				}

				// Attempt to create the enum
				var resolved:Enum<Dynamic> = Type.resolveEnum(enumName);
				if (resolved == null)
				{
					luaError("Could not resolve Enum '" + stringArg + "' for argument");
					newArgs.push(null);
				}
				else
					newArgs.push(resolved.createByName(enumName));
			}
			else if (stringArg.startsWith("OBJECT:"))
			{
				stringArg = stringArg.substring(8); // Remove "OBJECT:" from the front
				newArgs.push(toTargetObject(stringArg));
			}
		}
		return newArgs;
	}

	/** Converts a function/property output to something compatible with LUA. IE: turns an enum into a string **/
	function convertOutputToLUA(value:Dynamic):Dynamic
	{
		if (Reflect.isEnumValue(value))
			return Std.string(value);
		return value;
	}

	/** Uses reflection to get a property of an object. If the property is an enum, this returns the enum as a string. **/
	function getProperty(objectName:String, property:String):Dynamic
	{
		var o:Dynamic = toTargetObject(objectName);
		if (o == null)
			return null;

		if (!Reflect.hasField(o, property))
		{
			luaError("Could not get property '" + property + "': property not found");
			return null;
		}

		return convertOutputToLUA(Reflect.getProperty(o, property));
	}

	/** Uses reflection to set a property of an object. **/
	function setProperty(objectName:String, property:String, value:Dynamic)
	{
		var o:Dynamic = toTargetObject(objectName);
		if (o == null)
			return null;

		if (!Reflect.hasField(o, property))
		{
			luaError("Could not set property '" + property + "': property not found");
			return;
		}

		Reflect.setProperty(o, property, convertArgsFromLUA([value]));
	}

	/** Uses reflection to call a function of an object. **/
	function call(objectName:String, func:String, args:Array<Dynamic>):Dynamic
	{
		var o:Dynamic = toTargetObject(objectName);
		if (o == null)
			return null;

		if (!Reflect.hasField(o, func))
		{
			luaError("Could not call function '" + func + "': function not found");
			return null;
		}

		return convertOutputToLUA(Reflect.callMethod(o, Reflect.field(o, func), convertArgsFromLUA(args)));
	}

	/** Uses reflection to make an object. **/
	function make(className:String, args:Array<Dynamic>):Dynamic
	{
		var cl:Class<Dynamic> = Type.resolveClass(className);
		if (cl == null)
		{
			luaError("Could not make object: error resolving class '" + className + "'");
			return null;
		}
		return Type.createInstance(cl, args);
	}

	/** Uses reflection to make an object and store it in this scripts memory. **/
	function makeAndStore(name:String, className:String, args:Array<Dynamic>)
	{
		var o:Dynamic = make(className, convertArgsFromLUA(args));
		if (o == null)
			return;

		// Set the value in memory
		Reflect.setField(memory, name, o);
	}

	/** Forgets an object from this scripts memory. **/
	function forget(name:String)
	{
		if (!Reflect.hasField(memory, name))
		{
			luaError("Could not forget '" + name + "': object not found in this scripts memory");
			return;
		}
		Reflect.deleteField(memory, name);
	}

	function initVariables()
	{
		setLUAVariable("screenWidth", FlxG.width);
		setLUAVariable("screenHeight", FlxG.height);

		setLUAVariable("currentVersion", Main.currentVersion);
		setLUAVariable("latestVersion", Main.latestVersion);

		setLUAVariable("loadedLibraryCount", LibraryManager.libraries.entries.length);
	}

	function initCallbacks()
	{
		// Add the main/important callbacks
		addLUACallback("get", getProperty);
		addLUACallback("set", setProperty);
		addLUACallback("call", call);
		addLUACallback("make", makeAndStore);
		addLUACallback("forget", forget);

		// Add some extra callbacks for ease-of-use
		addLUACallback("closeApplication", function()
		{
			Application.current.window.close();
		});

		addLUACallback("switchState", function(stateName:String)
		{
			FlxG.switchState(make(stateName, []));
		});
		addLUACallback("openSubState", function(subStateName:String)
		{
			FlxG.state.openSubState(make(subStateName, []));
		});
		addLUACallback("closeSubState", function()
		{
			FlxG.state.closeSubState();
		});
		addLUACallback("addToState", function(objectName:String)
		{
			FlxG.state.add(toTargetObject(objectName));
		});
		addLUACallback("removeFromState", function(objectName:String)
		{
			FlxG.state.remove(toTargetObject(objectName), true);
		});
	}
}
