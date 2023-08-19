package gbc.scripting;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;

class ScriptRegistry extends Registry<Script>
{
	public function parse(data:Dynamic):Script
	{
		if (data == null || data.script == null)
			return null;
		return new Script(data.script, data.name);
	}

	public function export(item:Script, path:String)
	{
		var script:String = Json.stringify(item.script);
		FileManager.writeHScript(path, script);
	}

	function load(path:String):Script
	{
		return parse({
			script: FileManager.getHScript(path),
			name: path
		});
	}

	public static function getAsset(id:String):Script
	{
		return LibraryManager.getAsset(id, ScriptRegistry);
	}

	public static function getAssetID(item:Script):String
	{
		return LibraryManager.getAssetID(item, ScriptRegistry);
	}
}
