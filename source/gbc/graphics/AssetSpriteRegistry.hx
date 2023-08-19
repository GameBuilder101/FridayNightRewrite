package gbc.graphics;

import flixel.util.FlxColor;
import gbc.assets.FileManager;
import gbc.assets.LibraryManager;
import gbc.assets.Registry;
import gbc.graphics.AssetSprite;
import haxe.Json;
import openfl.display.BlendMode;

class AssetSpriteRegistry extends Registry<AssetSpriteData>
{
	public function parse(data:Dynamic):AssetSpriteData
	{
		if (data == null || data.graphic == null)
			return null;
		if (data.desc == null)
			data.desc = {};
		if (data.desc.animations == null)
			data.desc.animations = [];
		if (data.desc.flipX == null)
			data.desc.flipX = false;
		if (data.desc.flipY == null)
			data.desc.flipY = false;
		if (data.desc.color == null)
			data.desc.color = "#ffffff";
		if (data.desc.alpha == null)
			data.desc.alpha = 1.0;
		if (data.desc.blend == null)
			data.desc.blend = BlendMode.NORMAL;
		return {
			graphic: data.graphic,
			sparrowAtlas: data.sparrowAtlas,
			spriteSheetPacker: data.spriteSheetPacker,
			animations: data.desc.animations,
			defaultAnim: data.desc.defaultAnim,
			flipX: data.desc.flipX,
			flipY: data.desc.flipY,
			antialiasing: data.desc.antialiasing,
			color: FlxColor.fromString(data.desc.color),
			alpha: data.desc.alpha,
			blend: data.desc.blend,
			shaderID: data.desc.shaderID,
			shaderArgs: data.desc.shaderArgs
		};
	}

	public function export(item:AssetSpriteData, path:String)
	{
		if (item.sparrowAtlas != null)
			FileManager.writeXML(path, item.sparrowAtlas);
		if (item.spriteSheetPacker != null)
			FileManager.writeText(path, item.spriteSheetPacker);
		var desc:String = Json.stringify({
			animations: item.animations,
			defaultAnim: item.defaultAnim,
			flipX: item.flipX,
			flipY: item.flipY,
			antialiasing: item.antialiasing,
			color: item.color.toWebString(),
			alpha: item.alpha,
			blend: Type.enumConstructor(cast item.blend),
			shaderID: item.shaderID,
			shaderArgs: item.shaderArgs
		});
		FileManager.writeJson(path, desc);
	}

	function load(path:String):AssetSpriteData
	{
		return parse({
			graphic: FileManager.getGraphic(path),
			sparrowAtlas: FileManager.getXML(path),
			spriteSheetPacker: FileManager.getText(path),
			desc: FileManager.getParsedJson(path)
		});
	}

	public static function getAsset(id:String):AssetSpriteData
	{
		return LibraryManager.getAsset(id, AssetSpriteRegistry);
	}

	public static function getAssetID(item:AssetSpriteData):String
	{
		return LibraryManager.getAssetID(item, AssetSpriteRegistry);
	}
}
