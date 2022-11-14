package music;

import flixel.addons.ui.FlxUIState;

class ConductedState extends FlxUIState
{
	public var conductor(default, null):Conductor = new Conductor();

	/** The current BPM. **/
	public var bpm(default, null):Float;

	/** The current beat number. **/
	public var beat(default, null):Int;

	var prevBeat:Int = -1;

	override function create()
	{
		super.create();
		add(conductor);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		bpm = conductor.getCurrentBPM();
		beat = conductor.getCurrentBeat();
		if (prevBeat != beat)
		{
			prevBeat = beat;
			onBeat(beat);
		}
	}

	function onBeat(beat:Int) {}
}
