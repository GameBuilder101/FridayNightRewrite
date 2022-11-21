package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import openfl.media.Sound;

/** A container for music-related information. Note: these are not playable songs. Just background music or parts of song data. **/
class MusicData
{
	public var sound(default, null):Sound;
	public var volume(default, null):Float;
	public var bpmMap(default, null):Array<BPMChange>;

	public function new(sound:Sound, volume:Float, bpmMap:Array<BPMChange>)
	{
		this.sound = sound;
		this.volume = volume;
		this.bpmMap = bpmMap;
	}

	/** @param time The time in milliseconds. **/
	public function getBPMAt(time:Float):Float
	{
		var bpm:Float = 0.0;
		// Loop through all BPM changes. This assumes that the changes are in order of the time that they happen
		for (change in bpmMap)
		{
			// If we are now past the target time, stop and return what we had from the last BPM change
			if (change.time > time)
				return bpm;
			bpm = change.bpm;
		}
		return bpm;
	}

	/** Returns the total number/parts of beats that have passed by the given time. Warning: might be slow.
		@param time The time in milliseconds.
		@return EX: If 4 beats have passed, returns 4. If 4 beats have passed and it's half-way between beat 4 and 5, returns 4.5. **/
	public function getBeatAt(time:Float):Float
	{
		var beat:Float = 0;
		var i:Int = 0;
		/* We can't just use a simple equation to calculate this, since BPM changes mean you need
			to account for how many beats passed in previous BPM segments */
		for (change in bpmMap)
		{
			if (change.time >= time || i + 1 >= bpmMap.length)
				break;
			beat += (bpmMap[i + 1].time - change.time) * (change.bpm / 60000.0);
			i++;
		}
		beat += (time - bpmMap[i].time) * (bpmMap[i].bpm / 60000.0);
		return beat;
	}
}

typedef BPMChange =
{
	time:Float,
	bpm:Float
}

/** Use this to access/load music. Note: these are not playable songs. Just background music or parts of song data. **/
class MusicRegistry extends Registry<MusicData>
{
	static var cache:MusicRegistry = new MusicRegistry();

	function loadData(directory:String, id:String):MusicData
	{
		var path:String = Registry.getFullPath(directory, id);
		var parsed:Dynamic = FileManager.getParsedJson(path);
		if (parsed == null)
			return null;

		// Fill in default values if the data is missing
		if (parsed.volume == null)
			parsed.volume = 1.0;
		if (parsed.bpmMap == null || parsed.bpmMap.length <= 0)
			parsed.bpmMap = [{time: 0.0, bpm: 0.0}];

		var sound:Sound = FileManager.getSound(path);
		if (sound == null)
			return null;

		return new MusicData(sound, parsed.volume, parsed.bpmMap);
	}

	public static function getAsset(id:String):MusicData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
