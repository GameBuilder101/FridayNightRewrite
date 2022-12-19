package;

import lime.app.Application;
import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import hscript.plus.ScriptState;

class Script
{
	/** The ID used to load/identify the script. **/
	var id(default, null):String;

	var state:ScriptState = new ScriptState();

	public function new(script:String, id:String)
	{
		this.id = id;
		execute(script);
	}

	public function get(name:String):Dynamic
	{
		var value:Dynamic;
		try
		{
			value = state.get(name);
		}
		catch (e:Dynamic)
			error("could not get '" + name + "'");
		return value;
	}

	public function set(name:String, value:Dynamic)
	{
		try
		{
			state.set(name, value);
		}
		catch (e:Dynamic)
			error("could not set '" + name + "'");
	}

	public function execute(script:String)
	{
		try
		{
			state.executeString(script);
		}
		catch (e:Dynamic)
			error("could not execute: " + script + "");
	}

	/** Triggers an error and displays a warning from this script. **/
	inline function error(message:String)
	{
		var fullMessage:String = "Error on script '" + id + "'! " + message;
		Application.current.window.
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
