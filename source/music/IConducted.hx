package music;

interface IConducted
{
	public function updateMusic(time:Float, bpm:Float, beat:Float):Void;

	public function onWholeBeat(beat:Int):Void;
}
