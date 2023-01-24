package music;

import assetManagement.FileManager;
import openfl.media.Sound;

using StringTools;

class OldSongConverter
{
	/** Attempts to convert an old FNF song to the new format. Not guaranteed to work for
		everything.
		@param path The file path to the folder containing all difficulties.
	**/
	public static function convert(path:String):ConvertedSong
	{
		// Get the song ID based on the folder name
		var index:Int = path.lastIndexOf("/");
		if (index <= -1)
			index = path.lastIndexOf("\\");
		if (index <= -1)
			return null;
		var songID:String = path.substring(index + 1, path.length);

		// Get the parsed JSON data for each difficulty
		var easy:Dynamic = FileManager.getParsedJson(path + "/" + songID + "-easy");
		var normal:Dynamic = FileManager.getParsedJson(path + "/" + songID);
		var hard:Dynamic = FileManager.getParsedJson(path + "/" + songID + "-hard");
		if (easy == null && normal == null && hard == null)
			return null;

		// Set up the converted song
		var converted:ConvertedSong = {
			song: new Song(normal.song.song),
			instrumental: new MusicData(null, 1.0, []),
			voices: new SoundData([{sound: null, volume: 1.0}])
		};
		converted.song.opponentID = playerIDToCharacterID(normal.song.player2);
		converted.song.playerVariant = playerIDToVariantID(normal.song.player1);
		converted.song.opponentVariant = playerIDToVariantID(normal.song.player2);

		if (easy != null)
			converted.song.charts[0] = convertChart(converted, easy);
		if (normal != null)
			converted.song.charts[1] = convertChart(converted, normal);
		if (hard != null)
			converted.song.charts[2] = convertChart(converted, hard);

		return converted;
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
	static function convertChart(converted:ConvertedSong, parsed:Dynamic):Map<String, NoteChart>
	{
		var map:Map<String, NoteChart>;
		var playerChart:NoteChart;
		var opponentChart:NoteChart;

		var sectionTime:Float = 0.0; // Used to track when the section starts
		for (section in cast(parsed.song.notes, Array<Dynamic>))
		{
			if (section.changeBPM) // Add the BPM change to the map
				converted.instrumental.bpmMap.push({time: sectionTime, bpm: section.bpm});

			playerChart = new NoteChart([]);
			opponentChart = new NoteChart([]);
			var isPlayer = section.mustHitSection; // Whether this is a player note
			for (note in cast(section.sectionNotes, Array<Dynamic>))
			{
				if (note[1] > 3)
				{
					isPlayer = !isPlayer;
					note[1] -= 4;
				}
				if (isPlayer)
					playerChart.nodes.push(new Note());
			}

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
	// Used primarily for BPM map
	instrumental:MusicData,
	voices:SoundData
}
