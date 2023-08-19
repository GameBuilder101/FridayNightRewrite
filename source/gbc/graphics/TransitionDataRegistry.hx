package gbc.graphics;

import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import haxe.Json;

class TransitionDataRegistry extends Registry<TransitionData>
{
	public function parse(data:Dynamic):TransitionData
	{
		if (data == null || data.desc == null)
			return null;
		var tileData:TransitionTileData = null;
		if (data.graphic != null)
			tileData = {
				width: data.graphic.width,
				height: data.graphic.height,
				frameRate: data.frameRate,
				asset: data.graphic
			};
		return new TransitionData(data.desc.type, FlxColor.fromString(data.desc.color), data.desc.duration,
			new FlxPoint(data.desc.direction[0], data.desc.direction[1]), tileData);
	}

	public function export(item:TransitionData, path:String)
	{
		var desc:String = Json.stringify({
			type: Type.enumConstructor(cast item.type),
			color: item.color.toWebString(),
			duration: item.duration,
			direction: [item.direction.x, item.direction.y],
			frameRate: item.tileData.frameRate
		});
		FileManager.writeJson(path, desc);
	}

	function load(path:String):TransitionData
	{
		return parse({
			graphic: FileManager.getGraphic(path),
			desc: FileManager.getParsedJson(path)
		});
	}

	public static function getAsset(id:String):TransitionData
	{
		return LibraryManager.getAsset(id, TransitionDataRegistry);
	}

	public static function getAssetID(item:TransitionData):String
	{
		return LibraryManager.getAssetID(item, TransitionDataRegistry);
	}
}
