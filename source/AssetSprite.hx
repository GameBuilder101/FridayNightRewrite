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
	bottomAlign:Bool,
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

/** Use this to access/load asset-sprites. **/
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
		if (parsed.bottomAlign == null)
			parsed.bottomAlign = false;
		if (parsed.antialiasing == null)
			parsed.antialiasing = true;
		if (parsed.color == null)
			parsed.color = [255, 255, 255];
		if (parsed.alpha == null)
			parsed.alpha = 1.0;
		if (parsed.blend == null)
			parsed.blend = BlendMode.ALPHA;

		// Fill in default animation values if the data is missing
		for (animation in cast(parsed.animations, Array<Dynamic>))
		{
			if (animation.atlasPrefix == null)
				animation.atlasPrefix = "";
			if (animation.indices == null)
				animation.indices = [];
			if (animation.frameRate == null)
				animation.frameRate = 0;
			if (animation.looped == null)
				animation.looped = false;
			if (animation.flipX == null)
				animation.flipX = false;
			if (animation.offsetX == null)
				animation.offsetX = 0.0;
			if (animation.offsetY == null)
				animation.offsetY = 0.0;
		}

		return {
			bitmapData: bitmapData,
			sparrowAtlas: FileManager.getXML(path),
			spriteSheetPacker: FileManager.getText(path),
			bottomAlign: parsed.bottomAlign,
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

	/** When true, the asset-sprite sets the offsets based on the currently-playing animation from data. **/
	public var useAnimDataOffsets:Bool = true;

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

		// Remove any existing animations
		for (anim in animation.getAnimationList())
			animation.remove(anim.name);
		// Add the animations given the animation data
		for (animationData in data.animations)
			loadAnimation(animationData);

		antialiasing = data.antialiasing;
		color = data.color;
		alpha = data.alpha;
		blend = data.blend;
	}

	public function loadAnimation(data:AnimationData)
	{
		if (data.indices.length > 0)
			animation.add(data.name, data.indices, data.frameRate, data.looped, data.flipX);
		else
			animation.addByPrefix(data.name, data.atlasPrefix, data.frameRate, data.looped, data.flipX);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Set the offset to that of the currently-playing animation
		if (useAnimDataOffsets && animation.curAnim != null)
		{
			for (animationData in data.animations)
			{
				if (animation.curAnim.name == animationData.name)
				{
					offset.set(animationData.offsetX, animationData.offsetY);
					if (data.bottomAlign)
						offset.y += height;
					break;
				}
			}
		}
	}
}
