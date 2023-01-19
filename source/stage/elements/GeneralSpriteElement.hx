package stage.elements;

import AssetSprite.AssetSpriteData;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import music.IConducted;
import shader.ShaderResolver;

class GeneralSpriteElement extends AssetSprite implements IStageElement implements IConducted
{
	var bopAnimFrequency:Float;
	var bopAnimName:String;
	var bopLeftAnimName:String;
	var bopRightAnimName:String;
	var bopRight:Bool;

	public var enableBopAnim:Bool = true;

	var bopFrequency:Float;
	var bopScale:Float;
	var bopSpeed:Float;

	var originalScaleX:Float;
	var originalScaleY:Float;

	var flipXOnLoad:Bool;
	var flipYOnLoad:Bool;

	public function new(data:Dynamic)
	{
		if (data.flipX != null)
			flipXOnLoad = data.flipX;
		if (data.flipY != null)
			flipYOnLoad = data.flipY;
		super(0.0, 0.0, null, data.id);
		if (data.color != null)
			color *= FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);
		if (data.alpha != null)
			alpha *= data.alpha;
		if (data.blend != null)
			blend = data.blend;
		if (data.shaderType != null && Settings.getShaders())
			shader = ShaderResolver.resolve(data.shaderType, data.shaderArgs);

		bopAnimFrequency = data.bopAnimFrequency;
		bopAnimName = data.bopAnimName;
		bopLeftAnimName = data.bopLeftAnimName;
		bopRightAnimName = data.bopRightAnimName;

		bopFrequency = data.bopFrequency;
		bopScale = data.bopScale;
		bopSpeed = data.bopSpeed;
	}

	override function loadFromData(data:AssetSpriteData)
	{
		super.loadFromData(data);
		if (flipXOnLoad)
			flipX = !flipX;
		if (flipYOnLoad)
			flipY = !flipY;
	}

	public function onAddedToStage(stage:Stage)
	{
		originalScaleX = scale.x;
		originalScaleY = scale.y;
	}

	public function updateMusic(time:Float, bpm:Float, beat:Float) {}

	public function onWholeBeat(beat:Int)
	{
		if (enableBopAnim && bopAnimFrequency > 0 && beat % bopAnimFrequency == 0.0)
		{
			if (bopAnimName != null && animation.exists(bopAnimName)) // If there is a singular bop animation
				playAnimation(bopAnimName);
			else if (bopRight)
				playAnimation(bopRightAnimName);
			else
				playAnimation(bopLeftAnimName);
			bopRight = !bopRight;
		}

		if (bopFrequency > 0 && beat % bopFrequency == 0.0)
		{
			scale.set(bopScale, bopScale);
			FlxTween.tween(this, {"scale.x": originalScaleX, "scale.y": originalScaleY}, bopSpeed);
		}
	}
}
