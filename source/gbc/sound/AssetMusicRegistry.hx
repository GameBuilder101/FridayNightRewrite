package gbc.sound;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;

class AssetMusicRegistry extends Registry<AssetMusic>
{
	public function parse(data:Dynamic):AssetMusic
	{
		if (data == null || data.sound == null)
			return null;
		if (data.desc == null)
			data.desc = {volume: 1.0};
		return new AssetMusic(data.sound, data.desc.volume);
	}

	public function export(item:AssetMusic, path:String)
	{
		var desc:String = Json.stringify({
			volume: item.volume
		});
		FileManager.writeJson(path, desc);
	}

	function load(path:String):AssetMusic
	{
		return parse({
			sound: FileManager.getSound(path),
			desc: FileManager.getParsedJson(path)
		});
	}

	public static function getAsset(id:String):AssetMusic
	{
		return LibraryManager.getAsset(id, AssetMusicRegistry);
	}

	public static function getAssetID(item:AssetMusic):String
	{
		return LibraryManager.getAssetID(item, AssetMusicRegistry);
	}
}
