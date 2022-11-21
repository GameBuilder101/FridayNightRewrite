package music;

import flixel.FlxBasic;
import flixel.addons.ui.FlxUIState;

class ConductedState extends FlxUIState implements Conducted
{
	public var conductor(default, null):Conductor;

	override function create()
	{
		super.create();
		conductor = new Conductor(this);
		add(conductor);
	}

	public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		// Call on members
		forEach(function(member:FlxBasic)
		{
			if (member is Conducted)
				cast(member, Conducted).updateMusic(time, bpm, beat);
		}, true);
	}

	public function onWholeBeat(beat:Int)
	{
		// Call on members
		forEach(function(member:FlxBasic)
		{
			if (member is Conducted)
				cast(member, Conducted).onWholeBeat(beat);
		}, true);
	}
}
