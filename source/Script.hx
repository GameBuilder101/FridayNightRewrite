package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import haxe.CallStack;
import hscript.Expr;
import hscript.plus.InterpPlus;
import hscript.plus.ParserPlus;
import lime.app.Application;

/** A class to handle HScripts. **/
class Script
{
	var script:String;

	/** The directory used to load/identify the script. **/
	var directory(default, null):String;

	/** The ID used to load/identify the script. **/
	var id(default, null):String;

	var parser:ParserPlus;
	var interp:InterpPlus;

	var started:Bool;

	public function new(script:String, directory:String, id:String)
	{
		this.script = script;
		this.directory = directory;
		this.id = id;

		parser = new ParserPlus();
		parser.allowTypes = true;

		interp = new InterpPlus();
		interp.setResolveImportFunction(resolveImport);
	}

	/** Used to resolve imports of other custom scripts. The way this is handled is using
		library-relative directories. For example, to import a class Entity in a script titled
		entity_script under the global_scripts folder, you would use "global_scripts.entity_script.Entity"
		as the import. **/
	function resolveImport(packageName:String):Dynamic
	{
		var path:Array<String> = packageName.split(".");
		// A custom import should consist of more than just one thing.
		if (path.length <= 1)
		{
			error("Invalid import '" + packageName + "'. Either the import doesn't exist or the custom import is formatted incorrectly");
			return null;
		}

		/* The directory consists of everything before the script ID and the class name. If
			the custom script was placed in the root of a mod library, this may be empty. */
		var directory:String = "";
		if (path.length > 2)
		{
			for (i in 0...(path.length - 2))
				directory += path[i] + "/";
		}
		var id:String = path[path.length - 2];

		// Get the script
		var script:Script = ScriptRegistry.getAsset(directory + id);
		if (script == null)
		{
			error("Invalid custom import '" + packageName + "'. Could not find the given script");
			return null;
		}
		// Execute it so we can retrieve the class
		run(script.script);

		var className:String = path.pop();
		// Get the class from the executed script
		return get(className);
	}

	/** Initializes the script. If not called, this script will not be parsed or executed. **/
	public function start()
	{
		if (started)
			return;
		started = run(script, Registry.getFullPath(directory, id));
		if (!started)
			return;

		// If there is a "new" function, call that
		var newFunc:Dynamic = get("new");
		if (newFunc != null && Reflect.isFunction(newFunc))
			newFunc();
	}

	/** Attempts to parse and execute a script.
		@return Whether the execution was successful.
	**/
	function run(script:String, origin:String = "hscript"):Bool
	{
		// Try to parse the script
		var parsed:Expr;
		try
		{
			parsed = parser.parseString(script, origin);
		}
		catch (e:Dynamic)
		{
			error(e.line + ": characters " + e.pmin + " - " + e.pmax + ": " + e);
			return false;
		}

		// Try to run the script
		try
		{
			interp.execute(parsed);
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

	/** Triggers an error and displays a warning from this script. **/
	inline function error(message:String)
	{
		trace("Error on script '" + id + "'! " + message);
		Application.current.window.alert(message, "Error on script '" + id + "'!");
	}

	/** Useful for debugging from a script. **/
	public static function alert(message:String)
	{
		trace("Script alert: " + message);
		Application.current.window.alert(message, "Script Alert");
	}
}

/** Use this to access/load any script. **/
class ScriptRegistry extends Registry<Script>
{
	static var cache:ScriptRegistry = new ScriptRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
		});
	}

	function loadData(directory:String, id:String):Script
	{
		var script = FileManager.getHScript(Registry.getFullPath(directory, id));
		if (script == null)
			return null;
		return new Script(script, directory, id);
	}

	public static function getAsset(id:String):Script
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
