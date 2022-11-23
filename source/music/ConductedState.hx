package music;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import stage.Stage;

abstract class ConductedState extends FlxUIState implements Conducted
{
	public var conductor(default, null):Conductor;

	/** The music time from the previous frame. Used to track and call events. **/
	var prevEventTime:Float;

	public var stage(default, null):Stage;
	public var uiCamera(default, null):FlxCamera;

	override function create()
	{
		super.create();

		conductor = new Conductor(this);
		add(conductor);

		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.add(uiCamera, true);

		stage = createStage();
		if (stage != null)
			add(stage);
	}

	abstract function createStage():Stage;

	public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		// Call on members
		forEach(function(member:FlxBasic)
		{
			if (member is Conducted)
				cast(member, Conducted).updateMusic(time, bpm, beat);
		}, true);

		/* Trigger all events which occured between the previous time and the current time */
		for (event in Conductor.currentMusic.events)
		{
			if (event.time > prevEventTime && event.time <= time)
				event.trigger(this);
		}
		prevEventTime = time;
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
