package;

import GlobalScript;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import music.Conductor;
import music.Event;
import music.EventChart;
import music.IConducted;
import stage.Stage;

/** A state which has a conductor and handles other global things. Should be used for basically all states in the game. **/
abstract class ConductedState extends FlxTransitionableState implements IConducted
{
	public var conductor(default, null):Conductor;

	/** The currently-loaded event chart. **/
	public var eventChart(default, null):EventChart;

	/** The music time from the previous frame. Used to track and call events. **/
	var prevEventTime:Float;

	public var stage(default, null):Stage;
	public var uiCamera(default, null):FlxCamera;

	override function create()
	{
		super.create();
		persistentUpdate = true; // Makes it so the state is conducted even while transitioning in

		// Must be done after FlxG has a chance to initialize or else it throws an error
		Controls.initialize();
		Settings.initialize();

		// Must be called somewhere in a state (after initialization), since graphics (such as the transition tile) can't be obtained before then
		TransitionDataRegistry.updateDefaultTrans();
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		conductor = new Conductor(this);
		add(conductor);

		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.add(uiCamera, true);

		GlobalScriptRegistry.startAll();

		stage = createStage();
		if (stage != null)
		{
			add(stage);
			GlobalScriptRegistry.callAll("onStageCreated", [stage]);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Controls.updateSoundActions();
		GlobalScriptRegistry.callAll("onUpdate", [elapsed]);
	}

	abstract function createStage():Stage;

	public function updateMusic(time:Float, bpm:Float, beat:Float)
	{
		// Call on members
		forEach(function(member:FlxBasic)
		{
			if (member is IConducted)
				cast(member, IConducted).updateMusic(time, bpm, beat);
		}, true);

		if (eventChart != null)
		{
			/* Trigger all events which occured between the previous time and the current time */
			for (event in eventChart.nodes)
			{
				if (event.time > prevEventTime && event.time <= time)
					triggerEvent(event);
			}
			prevEventTime = time;
		}

		GlobalScriptRegistry.callAll("onUpdateMusic", [time, bpm, beat]);
	}

	public function onWholeBeat(beat:Int)
	{
		// Call on members
		forEach(function(member:FlxBasic)
		{
			if (member is IConducted)
				cast(member, IConducted).onWholeBeat(beat);
		}, true);

		GlobalScriptRegistry.callAll("onWholeBeat", [beat]);
	}

	function triggerEvent(event:Event) // In case extra functionality needs to be added
	{
		event.trigger(this);
	}
}
