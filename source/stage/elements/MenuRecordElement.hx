package stage.elements;

import flixel.tweens.FlxTween;

class MenuRecordElement extends GeneralSpriteElement
{
	/** Indicates how much of a full 360-rotation should occur per beat. **/
	var speed:Float;

	public function new(name:String, data:Dynamic)
	{
		super(name, data);
		speed = data.speed;
	}

	override public function onAddedToStage(stage:Stage)
	{
		// Has to be done here since updateHitbox() is called by the stage
		offset.set(width / 2.0, height / 2.0);
	}

	override public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		super.updateMusic(time, bpm, beat);
		angle = 360.0 * beat * speed;
	}

	override function onWholeBeat(beat:Int)
	{
		super.onWholeBeat(beat);
		if (beat % beatAnimFrequency == 0.0)
		{
			scale.set(1.01, 1.01);
			FlxTween.tween(this, {"scale.x": 1.0, "scale.y": 1.0}, 0.1);
		}
	}
}
