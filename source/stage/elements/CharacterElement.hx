package stage.elements;

class CharacterElement extends Character implements IStageElement
{
	public function new(data:Dynamic)
	{
		super(0.0, 0.0);
		if (data.flipX != null)
			flipX = data.flipX;
		if (data.flipY != null)
			flipY = data.flipY;
	}

	public function onAddedToStage(stage:Stage) {}
}
