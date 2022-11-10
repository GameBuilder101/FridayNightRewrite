package;

class Conductor
{
	/** The current BPM. **/
	public static var bpm:Float = 100.0;

	/** The beats in milliseconds. **/
	public static var crochet:Float = ((60.0 / bpm) * 1000.0);

	/** The steps in milliseconds. **/
	public static var stepCrochet:Float = crochet / 4.0;

	public static var currentTime:Float = 0;
}
