package music;

import flixel.FlxBasic;
import flixel.addons.ui.FlxUIState;

class ConductedState extends FlxUIState implements Conducted
{
	public var conductor(default, null):Conductor = new Conductor();

	var prevWholeBeat:Int = -1;

	override function create()
	{
		super.create();
		add(conductor);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		updateMusic(conductor.getTime(), conductor.getCurrentBPM(), conductor.getCurrentBeat());
	}

	/* The purpose of putting the update functionality into a separate method is that it's
		better for performance. getCurrentBeat() can sometimes be a slow calculation,
		so we want to avoid doing it more than once per frame */
	public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		// Call updateMusic() on members
		forEach(function(member:FlxBasic)
		{
			if (member is Conducted)
				cast(member, Conducted).updateMusic(time, bpm, beat);
		}, true);

		if (prevWholeBeat != Std.int(beat))
		{
			prevWholeBeat = Std.int(beat);
			onWholeBeat(prevWholeBeat);
		}
	}

	public function onWholeBeat(beat:Int)
	{
		// Call onWholeBeat() on members
		forEach(function(member:FlxBasic)
		{
			if (member is Conducted)
				cast(member, Conducted).onWholeBeat(beat);
		}, true);
	}
}
