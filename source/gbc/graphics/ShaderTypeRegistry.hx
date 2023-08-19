package gbc.graphics;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;

class ShaderTypeRegistry extends Registry<ShaderType>
{
	public function parse(data:Dynamic):ShaderType
	{
		if (data == null)
			return null;
		return new ShaderType(data.builtin);
	}

	public function export(item:ShaderType, path:String)
	{
		var desc:String = Json.stringify({
			builtin: item.builtin
		});
		FileManager.writeJson(path, desc);
	}

	function load(path:String):ShaderType
	{
		return parse(FileManager.getParsedJson(path));
	}

	public static function getAsset(id:String):ShaderType
	{
		return LibraryManager.getAsset(id, ShaderTypeRegistry);
	}

	public static function getAssetID(item:ShaderType):String
	{
		return LibraryManager.getAssetID(item, ShaderTypeRegistry);
	}
}
