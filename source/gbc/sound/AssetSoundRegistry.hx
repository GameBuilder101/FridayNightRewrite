package gbc.sound;

import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import gbc.sound.AssetSound;
import haxe.Json;
import openfl.media.Sound;

class AssetSoundRegistry extends Registry<AssetSound>
{
	public function parse(data:Dynamic):AssetSound
	{
		if (data.desc != null)
		{
			var variants:Array<AssetSoundVariant> = [];
			var i:Int = 0;
			for (volume in cast(data.desc, Array<Dynamic>))
			{
				variants.push({sound: data.sounds[i], volume: volume});
				i++;
			}
			return new AssetSound(variants);
		}
		else if (data.sound != null) // If it's just a sound file without a JSON
			return new AssetSound(null, {sound: data.sound, volume: 1.0});
		return null;
	}

	public function export(item:AssetSound, path:String)
	{
		var volumes:Array<Float> = [];
		for (variant in item.variants)
			volumes.push(variant.volume);
		var desc:String = Json.stringify(volumes);
		FileManager.writeJson(path, desc);
	}

	function load(path:String):AssetSound
	{
		var desc:Dynamic = FileManager.getParsedJson(path);
		var sounds:Array<Sound> = [];
		if (desc != null)
		{
			for (i in 0...cast(desc, Array<Dynamic>).length)
				sounds.push(FileManager.getSound(path + "_" + i));
		}
		return parse({
			sound: FileManager.getSound(path),
			sounds: sounds,
			desc: desc
		});
	}

	public static function getAsset(id:String):AssetSound
	{
		return LibraryManager.getAsset(id, AssetSoundRegistry);
	}

	public static function getAssetID(item:AssetSound):String
	{
		return LibraryManager.getAssetID(item, AssetSoundRegistry);
	}
}
