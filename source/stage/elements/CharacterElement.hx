package stage.elements;

class CharacterElement extends Character implements IStageElement
{
	public function new(data:Dynamic)
	{
		super(0.0, 0.0);
		if (data.flipX != null && data.flipX)
			flipX = !flipX;
		if (data.flipY != null && data.flipY)
			flipY = !flipY;
	}

	public function onAddedToStage(stage:Stage) {}
}
