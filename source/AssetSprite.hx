package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.BlendMode;

typedef AssetSpriteData =
{
	bitmapData:BitmapData,
	sparrowAtlas:String,
	spriteSheetPacker:String,
	animations:Array<AnimationData>,
	antialiasing:Bool,
	color:FlxColor,
	alpha:Float,
	blend:BlendMode
}

typedef AnimationData =
{
	name:String,
	atlasPrefix:String,
	indices:Array<Int>,
	frameRate:Int,
	looped:Bool,
	flipX:Bool,
	offsetX:Float,
	offsetY:Float
}

class AssetSpriteRegistry extends Registry<AssetSpriteData>
{
	static var cache:AssetSpriteRegistry = new AssetSpriteRegistry();

	function loadData(directory:String, id:String):AssetSpriteData
	{
		var path:String = Registry.getFullPath(directory, id);
		var bitmapData:BitmapData = FileManager.getBitmapData(path);
		if (bitmapData == null) // If the graphic doesn't exist, then don't add asset sprite data for it
			return null;

		var parsed:Dynamic = FileManager.getParsedJson(path);
		if (parsed == null)
			parsed = {};
		// Fill in default values if the data is missing
		if (parsed.animations == null)
			parsed.animations = [];
		if (parsed.antialiasing == null)
			parsed.antialiasing = true;
		if (parsed.color == null)
			parsed.color = [255, 255, 255];
		if (parsed.alpha == null)
			parsed.alpha = 1.0;
		if (parsed.blend == null)
			parsed.blend = BlendMode.ALPHA;

		return {
			bitmapData: bitmapData,
			sparrowAtlas: FileManager.getXML(path),
			spriteSheetPacker: FileManager.getText(path),
			animations: parsed.animations,
			antialiasing: parsed.antialiasing,
			color: FlxColor.fromRGB(parsed.color[0], parsed.color[1], parsed.color[2]),
			alpha: parsed.alpha,
			blend: parsed.blend
		};
	}

	public static function getAsset(id:String):AssetSpriteData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}

/** Asset-sprites are meant to be a way to simplify and universalize sprite creation.
	Information about a sprite's animations, frames, colors, etc. can be supplied through
	a JSON file and then loaded in dynamically to create the sprite. **/
class AssetSprite extends FlxSprite
{
	public var data(default, null):AssetSpriteData;

	/**
		@param data Data to be loaded on creation.
		@param id When supplied, the sprite data will be retrieved via AssetSpriteRegistry.getAsset.
	**/
	public function new(x:Float, y:Float, ?data:AssetSpriteData = null, ?id:String = null)
	{
		super(x, y);
		if (data != null)
			loadFromData(data);
		else if (id != null)
		{
			var foundData:AssetSpriteData = AssetSpriteRegistry.getAsset(id);
			if (foundData != null)
				loadFromData(foundData);
		}
	}

	/** Loads the sprite information (such as frames and animations) from the provided data. **/
	public function loadFromData(data:AssetSpriteData)
	{
		this.data = data;
		if (data.sparrowAtlas != null)
			frames = FlxAtlasFrames.fromSparrow(data.bitmapData, data.sparrowAtlas);
		else if (data.spriteSheetPacker != null)
			frames = FlxAtlasFrames.fromSpriteSheetPacker(data.bitmapData, data.spriteSheetPacker);
		else
			loadGraphic(data.bitmapData);

		// Add the animations given the animation data
		for (animationData in data.animations)
		{
			if (animationData.indices != null)
				animation.add(animationData.name, animationData.indices, animationData.frameRate, animationData.looped, animationData.flipX);
			else
				animation.addByPrefix(animationData.name, animationData.atlasPrefix, animationData.frameRate, animationData.looped, animationData.flipX);
		}

		antialiasing = data.antialiasing;
		color = data.color;
		alpha = data.alpha;
		blend = data.blend;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Set the offset to that of the currently-playing animation
		if (animation.curAnim != null)
		{
			for (animationData in data.animations)
			{
				if (animation.curAnim.name == animationData.name)
				{
					offset.set(animationData.offsetX, animationData.offsetY);
					break;
				}
			}
		}
	}
}
