package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import hscript.plus.ParserPlus;
import hscript.plus.ParserInterp;
import lime.app.Application;

/** A class to handle HScripts. **/
class Script
{
	var script:String;

	/** The ID used to load/identify the script. **/
	var id(default, null):String;

	var parser:ScriptState;

	var started:Bool;

	public function new(script:String, id:String)
	{
		this.script = script;
		this.id = id;
		state = new ScriptState();
		state.rethrowError = true; // Errors are handled manually in this class
	}

	/** Initializes the script. **/
	public inline function start()
	{
		if (started)
			return;
		started = true;
		execute(script);
	}

	public function get(name:String):Dynamic
	{
		var value:Dynamic = null;
		try
		{
			value = state.get(name);
		}
		catch (e:Dynamic)
			error("Could not get '" + name + "': " + e);
		return value;
	}

	public function set(name:String, value:Dynamic)
	{
		try
		{
			state.set(name, value);
		}
		catch (e:Dynamic)
			error("Could not set '" + name + "': " + e);
	}

	public function execute(script:String)
	{
		try
		{
			state.executeString(script);
		}
		catch (e:Dynamic)
			error("Could not execute: " + e);
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

abstract class ScriptRegistry extends Registry<Script>
{
	function loadData(directory:String, id:String):Script
	{
		var script = FileManager.getHScript(Registry.getFullPath(directory, id));
		if (script == null)
			return null;
		return new Script(script, id);
	}
}

/** Use this to access/load global scripts. **/
class GlobalScriptRegistry extends ScriptRegistry
{
	static var cache:GlobalScriptRegistry = new GlobalScriptRegistry();
	static var cachedIDs:Array<String>;

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
			cachedIDs = [];
		});
	}

	public static function getAsset(id:String):Script
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("global_scripts");
		return cachedIDs;
	}
}
