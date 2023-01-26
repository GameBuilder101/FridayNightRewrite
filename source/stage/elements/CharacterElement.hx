package stage.elements;

class CharacterElement extends Character implements IStageElement
{
	public var singerTag:String;

	public function new(data:Dynamic)
	{
		super(0.0, 0.0);
		singerTag = data.singerTag;
		if (data.flipX != null)
			flipX = data.flipX;
		if (data.flipY != null)
			flipY = data.flipY;
	}

	public function onAddedToStage(stage:Stage) {}
}
