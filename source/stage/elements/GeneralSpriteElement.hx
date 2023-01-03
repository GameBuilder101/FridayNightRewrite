package stage.elements;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import music.IConducted;
import shader.ShaderResolver;

class GeneralSpriteElement extends AssetSprite implements IStageElement implements IConducted
{
	var bopAnimFrequency:Float;
	var bopLeftAnimName:String;
	var bopRightAnimName:String;
	var bopRight:Bool;

	var bopFrequency:Float;
	var bopScale:Float;
	var bopSpeed:Float;

	var originalScaleX:Float;
	var originalScaleY:Float;

	public function new(data:Dynamic)
	{
		super(0.0, 0.0, null, data.id);
		if (data.flipX != null && data.flipX)
			flipX = !flipX;
		if (data.flipY != null && data.flipY)
			flipY = !flipY;
		if (data.color != null)
			color *= FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);
		if (data.alpha != null)
			alpha *= data.alpha;
		if (data.blend != null)
			blend = data.blend;
		if (data.shaderType != null && Settings.getShaders())
			shader = ShaderResolver.resolve(data.shaderType, data.shaderArgs);

		bopAnimFrequency = data.bopAnimFrequency;
		if (data.bopAnimName != null) // If there is a single bop animation
		{
			bopLeftAnimName = data.bopAnimName;
			bopRightAnimName = data.bopAnimName;
		}
		else
		{
			bopLeftAnimName = data.bopLeftAnimName;
			bopRightAnimName = data.bopRightAnimName;
		}

		bopFrequency = data.bopFrequency;
		bopScale = data.bopScale;
		bopSpeed = data.bopSpeed;

		if (data.defaultAnim != null)
			playAnimation(data.defaultAnim, true);
	}

	public function onAddedToStage(stage:Stage)
	{
		originalScaleX = scale.x;
		originalScaleY = scale.y;
	}

	public function updateMusic(time:Float, bpm:Float, beat:Float) {}

	public function onWholeBeat(beat:Int)
	{
		if (bopAnimFrequency > 0 && beat % bopAnimFrequency == 0.0)
		{
			if (bopRight)
				playAnimation(bopRightAnimName, true);
			else
				playAnimation(bopLeftAnimName, true);
			bopRight = !bopRight;
		}

		if (bopFrequency > 0 && beat % bopFrequency == 0.0)
		{
			scale.set(bopScale, bopScale);
			FlxTween.tween(this, {"scale.x": originalScaleX, "scale.y": originalScaleY}, bopSpeed);
		}
	}
}
