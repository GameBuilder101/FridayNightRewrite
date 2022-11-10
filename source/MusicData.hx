package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import openfl.media.Sound;

/** A container for music-related information. Note: these are not playable songs. Just background music or parts of song data. **/
class MusicData
{
	var sound(default, null):Sound;
	var volume(default, null):Float;
	var bpmMap(default, null):Array<BPMChange>;

	public function new(sound:Sound, volume:Float, bpmMap:Array<BPMChange>)
	{
		this.sound = sound;
		this.volume = volume;
		this.bpmMap = bpmMap;
	}

	/** Plays the music on the conductor. **/
	public function play() {}
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
