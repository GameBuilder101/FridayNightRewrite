package gbc.graphics;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

typedef AssetSpriteData =
{
	graphic:FlxGraphic,
	sparrowAtlas:String,
	spriteSheetPacker:String,
	animations:Array<AssetSpriteAnimation>,
	defaultAnim:String,
	flipX:Bool,
	flipY:Bool,
	antialiasing:Bool,
	color:FlxColor,
	alpha:Float,
	blend:BlendMode,
	shaderID:String,
	shaderArgs:Dynamic
}

typedef AssetSpriteAnimation =
{
	name:String,
	atlasPrefix:String,
	indices:Array<Int>,
	frameRate:Int,
	looped:Bool,
	offset:Array<Float>
}

/** An asset-sprite can have visual and animation properties defined
	in a JSON file and loaded at runtime. **/
class AssetSprite extends FlxSprite
{
	/** Used to apply offsets to animations. **/
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();

	public function new(x:Float = 0.0, y:Float = 0.0, data:AssetSpriteData = null, id:String = null)
	{
		super(x, y);
		if (data != null)
			load(data);
		else if (id != null)
			loadFromID(id);
	}

	/** Loads all values from the given data. **/
	public function load(data:AssetSpriteData)
	{
		// Load the graphic/spritesheet
		if (data.sparrowAtlas != null)
			frames = FlxAtlasFrames.fromSparrow(data.graphic, data.sparrowAtlas);
		else if (data.spriteSheetPacker != null)
			frames = FlxAtlasFrames.fromSpriteSheetPacker(data.graphic, data.spriteSheetPacker);
		else
			loadGraphic(data.graphic);

		// Remove any existing animations
		for (anim in animation.getAnimationList())
			animation.remove(anim.name);
		animOffsets.clear();
		// Add the animations given the animation data
		for (anim in data.animations)
		{
			if (anim.indices != null && anim.indices.length > 0)
				animation.addByIndices(anim.name, anim.atlasPrefix, anim.indices, "", anim.frameRate, anim.looped);
			else
				animation.addByPrefix(anim.name, anim.atlasPrefix, anim.frameRate, anim.looped);

			if (anim.offset != null)
				animOffsets.set(anim.name, anim.offset);
		}

		// Play the default animation
		if (data.defaultAnim != null)
			animation.play(data.defaultAnim, true);

		flipX = data.flipX;
		flipY = data.flipY;
		antialiasing = data.antialiasing;
		color = data.color;
		alpha = data.alpha;
		blend = data.blend;

		// Set the shader if one was defined
		if (data.shaderID != null)
		{
			var type:ShaderType = ShaderTypeRegistry.getAsset(data.shaderID);
			if (type != null)
				shader = type.create(data.shaderArgs);
		}
	}

	public function loadFromID(id:String)
	{
		load(AssetSpriteRegistry.getAsset(id));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (shader is IUpdateableShader)
			cast(shader, IUpdateableShader).update(elapsed);
	}

	override function updateAnimation(elapsed:Float)
	{
		super.updateAnimation(elapsed);
		if (animation.name == null)
			return;
		if (animOffsets.exists(animation.name))
		{
			var offset:Array<Float> = animOffsets[animation.name];
			this.offset.set(offset[0], offset[1]);
		}
	}
}
