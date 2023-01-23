package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import openfl.media.Sound;

/** A container for music-related information. Note: these are not playable songs. Just background music or parts of song data. **/
class MusicData
{
	public var sound(default, null):Sound;
	public var volume:Float;
	public var bpmMap:Array<BPMChange>;

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

	/** Returns the number of beats within a BPM change. **/
	public static inline function getBeatsIn(change:BPMChange, endTime:Float)
	{
		return (endTime - change.time) * (change.bpm / 60000.0);
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
			if (i + 1 >= bpmMap.length || change.time >= time)
				break;
			beat += getBeatsIn(change, bpmMap[i + 1].time);
			i++;
		}
		// Add all beats between the latest BPM change and the current time
		beat += getBeatsIn(bpmMap[i], time);
		return beat;
	}

	/** Returns the time at which a beat plays. **/
	public function getTimeAt(beat:Float):Float
	{
		var time:Float = 0;
		var i:Int = 0;
		var iBeats:Float = 0; // Used to track beats counted
		/* We can't just use a simple equation to calculate this, since BPM changes mean you need
			to account for how many beats passed in previous BPM segments */
		for (change in bpmMap)
		{
			if (i + 1 >= bpmMap.length)
				break;
			iBeats += getBeatsIn(change, bpmMap[i + 1].time);
			if (iBeats >= beat)
				break;
			time += bpmMap[i + 1].time - change.time;
			i++;
		}
		// Add all time between the latest BPM change and the current beat
		time += (beat - iBeats) / (bpmMap[i].bpm / 60000.0);
		return time;
	}
}

typedef BPMChange =
{
	time:Float,
	bpm:Float
}

/** Note: these are not playable songs. Just background music or parts of song data. **/
class MusicDataRegistry extends Registry<MusicData>
{
	static var cache:MusicDataRegistry = new MusicDataRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
		});
		LibraryManager.onPreload.push(function(libraryPath:String)
		{
			var parsed:Dynamic = FileManager.getParsedJson(libraryPath + "/preload_music_data");
			if (parsed == null)
				return;
			for (item in cast(parsed, Array<Dynamic>))
				getAsset(item);
		});
	}

	function loadData(directory:String, id:String):MusicData
	{
		var path:String = Registry.getFullPath(directory, id);
		var sound:Sound = FileManager.getSound(path);
		if (sound == null)
			return null;

		var parsed:Dynamic = FileManager.getParsedJson(path, ".music"); // Custom file extension to make stuff nicer
		if (parsed == null)
			return null;

		if (parsed.volume == null)
			parsed.volume = 1.0;
		if (parsed.events == null)
			parsed.events = [];

		return new MusicData(sound, parsed.volume, parsed.bpmMap);
	}

	public static function getAsset(id:String):MusicData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
