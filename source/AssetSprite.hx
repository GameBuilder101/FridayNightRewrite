package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import openfl.display.BlendMode;
import shader.IUpdatableShader;
import shader.ShaderResolver;

typedef AssetSpriteData =
{
	graphic:FlxGraphic,
	sparrowAtlas:String,
	spriteSheetPacker:String,
	flipX:Bool,
	flipY:Bool,
	animations:Array<AnimationData>,
	defaultAnim:String,
	antialiasing:Bool,
	color:FlxColor,
	alpha:Float,
	blend:BlendMode,
	shaderType:String,
	shaderArgs:Dynamic
}

typedef AnimationData =
{
	name:String,
	atlasPrefix:String,
	indices:Array<Int>,
	frameRate:Int,
	looped:Bool,
	offsetX:Float,
	offsetY:Float
}

/** Use this to access/load asset-sprite data. **/
class AssetSpriteDataRegistry extends Registry<AssetSpriteData>
{
	static var cache:AssetSpriteDataRegistry = new AssetSpriteDataRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
		});
		LibraryManager.onPreload.push(function(libraryPath:String)
		{
			var parsed:Dynamic = FileManager.getParsedJson(libraryPath + "/preload_sprite_data");
			if (parsed == null)
				return;
			for (item in cast(parsed, Array<Dynamic>))
				getAsset(item);
		});
	}

	function loadData(directory:String, id:String):AssetSpriteData
	{
		var path:String = Registry.getFullPath(directory, id);
		var graphic:FlxGraphic = FileManager.getGraphic(path);
		if (graphic == null) // If the graphic doesn't exist, then don't add asset sprite data for it
			return null;

		var parsed:Dynamic = FileManager.getParsedJson(path, ".sprite"); // Custom file extension to make stuff nicer
		if (parsed == null)
			parsed = {};

		// Fill in default values if the data is missing
		if (parsed.animations == null)
			parsed.animations = [];
		if (parsed.flipX == null)
			parsed.flipX = false;
		if (parsed.flipY == null)
			parsed.flipY = false;
		if (parsed.antialiasing == null)
			parsed.antialiasing = true;
		if (parsed.color == null)
			parsed.color = [255, 255, 255];
		if (parsed.alpha == null)
			parsed.alpha = 1.0;
		if (parsed.blend == null)
			parsed.blend = BlendMode.NORMAL;

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
			if (animation.offsetX == null)
				animation.offsetX = 0.0;
			if (animation.offsetY == null)
				animation.offsetY = 0.0;
		}

		return {
			graphic: graphic,
			sparrowAtlas: FileManager.getXML(path),
			spriteSheetPacker: FileManager.getText(path),
			flipX: parsed.flipX,
			flipY: parsed.flipY,
			animations: parsed.animations,
			defaultAnim: parsed.defaultAnim,
			antialiasing: parsed.antialiasing,
			color: FlxColor.fromRGB(parsed.color[0], parsed.color[1], parsed.color[2]),
			alpha: parsed.alpha,
			blend: parsed.blend,
			shaderType: parsed.shaderType,
			shaderArgs: parsed.shaderArgs
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
			loadFromID(id);
	}

	/** Loads the sprite information (such as frames and animations) from the provided data. **/
	public function loadFromData(data:AssetSpriteData)
	{
		this.data = data;
		if (data.sparrowAtlas != null)
			frames = FlxAtlasFrames.fromSparrow(data.graphic, data.sparrowAtlas);
		else if (data.spriteSheetPacker != null)
			frames = FlxAtlasFrames.fromSpriteSheetPacker(data.graphic, data.spriteSheetPacker);
		else
			loadGraphic(data.graphic);

		// Remove any existing animations
		for (anim in animation.getAnimationList())
			animation.remove(anim.name);
		// Add the animations given the animation data
		for (animationData in data.animations)
			loadAnimation(animationData);
		if (data.defaultAnim != null)
			playAnimation(data.defaultAnim, true);

		flipX = data.flipX;
		flipY = data.flipY;

		// Only allow antialiasing if enabled in settings
		if (Settings.getAntialiasing())
			antialiasing = data.antialiasing;
		else
			antialiasing = false;

		color = data.color;
		alpha = data.alpha;
		blend = data.blend;

		// Only allow shaders if enabled in settings
		if (data.shaderType != null && Settings.getShaders())
			shader = ShaderResolver.resolve(data.shaderType, data.shaderArgs);
	}

	public function loadFromID(id:String)
	{
		var data:AssetSpriteData = AssetSpriteDataRegistry.getAsset(id);
		if (data != null)
			loadFromData(data);
	}

	public function loadAnimation(data:AnimationData)
	{
		if (data.indices.length > 0)
			animation.addByIndices(data.name, data.atlasPrefix, data.indices, "", data.frameRate, data.looped);
		else
			animation.addByPrefix(data.name, data.atlasPrefix, data.frameRate, data.looped);
	}

	/** There must be a separate function for this so the animation offset ais set correctly. **/
	public function playAnimation(animName:String, force:Bool = false, reversed:Bool = false)
	{
		if (!animation.exists(animName))
			return;
		animation.play(animName, force, reversed);
		updateAnimationOffset();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		updateAnimationOffset(); // Call here in case scale changes while playing an animation

		// Update the shader if it supports the functionality
		if (shader != null && shader is IUpdatableShader)
			cast(shader, IUpdatableShader).update(elapsed);
	}

	function updateAnimationOffset()
	{
		if (animation.name == null)
			return;
		for (animationData in data.animations)
		{
			if (animation.name == animationData.name)
			{
				offset.set(animationData.offsetX * scale.x, animationData.offsetY * scale.y);
				break;
			}
		}
	}
}
