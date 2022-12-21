package stage.elements;

import flixel.math.FlxMath;

class SwayingSpriteElement extends GeneralSpriteElement
{
	/** When 1, the sprite will sway back and forth once within a single beat. **/
	public var swaySpeed:Float;

	public var swayDistance:Float;

	public function new(data:Dynamic)
	{
		super(data);
		swaySpeed = data.swaySpeed;
		swayDistance = data.swayDistance;
	}

	override public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		super.updateMusic(time, bpm, beat);
		angle = FlxMath.fastSin(2 * Math.PI * beat * swaySpeed) * swayDistance;
	}
}
