package music;

import assetManagement.FileManager;

using StringTools;

class OldSongConverter
{
	/** Attempts to convert an old FNF song to the new format. Not guaranteed to work for
		everything.
		@param path The file path to the folder containing all difficulties.
	**/
	public static function convert(path:String, instrumentalPath:String, voicesPath:String):ConvertedSong
	{
		var songID:String = path.substring(path.lastIndexOf("/") + 1, path.length);
		// Get the parsed JSON data for each difficulty
		var easy:Dynamic = FileManager.getParsedJson(path + "/" + songID + "-easy");
		var normal:Dynamic = FileManager.getParsedJson(path + "/" + songID);
		var hard:Dynamic = FileManager.getParsedJson(path + "/" + songID + "-hard");
		if (easy == null && normal == null && hard == null)
			return null;

		var instrumental:MusicData = new MusicData(FileManager.getSound(instrumentalPath), 1.0, []);
		var voices:SoundData = new SoundData([{sound: FileManager.getSound(voicesPath), volume: 1.0}]);

		// Set up the converted song
		var song:Song = new Song(normal.song.song);
		song.opponentID = playerIDToCharacterID(normal.song.player2);
		song.playerVariant = playerIDToVariantID(normal.song.player1);
		song.opponentVariant = playerIDToVariantID(normal.song.player2);
		if (easy != null)
			song.charts[0] = convertChart(song, easy);
		if (normal != null)
			song.charts[1] = convertChart(song, normal);
		if (hard != null)
			song.charts[2] = convertChart(song, hard);

		return song;
	}

	static inline function playerIDToCharacterID(player:String):String
	{
		// Remove things like -car and -christmas
		if (player.contains("-"))
			return player.substring(0, player.lastIndexOf("-"));
		return player;
	}

	static function playerIDToVariantID(player:String):String
	{
		if (player.contains("-"))
			return player.substring(player.lastIndexOf("-") + 1, player.length);
		return "normal";
	}

	/** Converts the charts from an old song into charts for a new song. **/
	static function convertChart(song:Song, parsed:Dynamic):Map<String, NoteChart>
	{
		var map:Map<String, NoteChart>;
		var playerChart:NoteChart = new NoteChart([]);
		var opponentChart:NoteChart = new NoteChart([]);

		var sectionTime:Float = 0.0; // Used to track when the section starts
		for (section in cast(parsed.song.notes, Array<Dynamic>))
		{
			if (section.changeBPM)
				song.instrumental.bpmMap.push(sectionTime, section.bpm);
			sectionTime += section.lengthInSteps;
		}

		map.set("player", playerChart);
		map.set("opponent", opponentChart);
		return map;
	}
}

typedef ConvertedSong =
{
	song:Song,
	instrumental:MusicData,
	voices:SoundData
}
