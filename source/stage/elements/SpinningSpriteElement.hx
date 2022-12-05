package stage.elements;

class SpinningSpriteElement extends GeneralSpriteElement
{
	/** Indicates how much of a full 360-rotation should occur per beat. **/
	public var spinSpeed:Float;

	public function new(data:Dynamic)
	{
		super(data);
		spinSpeed = data.spinSpeed;
	}

	override public function onAddedToStage(stage:Stage)
	{
		super.onAddedToStage(stage);
	}

	override public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		super.updateMusic(time, bpm, beat);
		angle = 360.0 * beat * spinSpeed;
	}
}
