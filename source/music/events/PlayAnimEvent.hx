package music.events;

import flixel.FlxSprite;

/** Plays an animation on a stage element. **/
class PlayAnimEvent extends MusicEvent
{
	public function trigger(state:ConductedState)
	{
		var elements:Array<FlxSprite> = state.stage.getElementsWithTag(args.targetTag);
		for (element in elements)
			element.animation.play(args.name, true);
	}
}
