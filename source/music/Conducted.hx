package music;

interface Conducted
{
	public function updateMusic(time:Float, bpm:Float, beat:Float):Void;

	public function onWholeBeat(beat:Int):Void;
}
