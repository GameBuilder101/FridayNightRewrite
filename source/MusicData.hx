package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import openfl.media.Sound;

class MusicData
{
	var sound(default, null):Sound;
	var volume(default, null):Float;
	var bpm(default, null):Float;

	public function new(sound:Sound, volume:Float, bpm:Float)
	{
		this.sound = sound;
		this.volume = volume;
		this.bpm = bpm;
	}

	/** Plays the music on the conductor. **/
	public function play() {}
}

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
		return new MusicData(sound, parsed.volume, parsed.bpm);
	}

	public static function getAsset(id:String):MusicData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
