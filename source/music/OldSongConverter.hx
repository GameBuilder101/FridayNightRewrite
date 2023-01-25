package music;

import assetManagement.FileManager;
import music.Note;
import music.Song;

using StringTools;

class OldSongConverter
{
	/** Attempts to convert an old FNF song to the new format. Not guaranteed to work for
		everything.
		@param dataPath The file path to the folder containing all difficulties.
		@param soundPath The file path to the folder containing instrumental and voices.
	**/
	public static function convert(dataPath:String, soundPath:String):ConvertedSong
	{
		// Get the song ID based on the folder name
		var index:Int = dataPath.lastIndexOf("/");
		if (index <= -1)
			index = dataPath.lastIndexOf("\\");
		if (index <= -1)
			return null; // If some idiot tried to convert from the root
		var songID:String = dataPath.substring(index + 1, dataPath.length);

		// Get the parsed JSON data for each difficulty
		var easy:Dynamic = FileManager.getParsedJson(dataPath + "/" + songID + "-easy");
		var normal:Dynamic = FileManager.getParsedJson(dataPath + "/" + songID);
		var hard:Dynamic = FileManager.getParsedJson(dataPath + "/" + songID + "-hard");
		if (easy == null && normal == null && hard == null)
			return null;

		// Set up the converted song
		var converted:ConvertedSong = {
			song: new Song(normal.song.song),
			instrumentalPath: soundPath + "/Inst",
			instrumental: new MusicData(FileManager.getSound(soundPath + "/Inst"), 1.0, []),
			voicesPath: soundPath + "/Voices",
			voices: new SoundData([
				{
					sound: FileManager.getSound(soundPath + "/Voices"),
					volume: 1.0
				}
			])
		};
		converted.song.opponentID = playerIDToCharacterID(normal.song.player2);
		converted.song.playerVariant = playerIDToVariantID(normal.song.player1);
		converted.song.opponentVariant = playerIDToVariantID(normal.song.player2);

		if (easy != null)
			converted.song.difficulties[0] = convertDifficulty(converted, easy);
		if (normal != null)
			converted.song.difficulties[1] = convertDifficulty(converted, normal);
		if (hard != null)
			converted.song.difficulties[2] = convertDifficulty(converted, hard);

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
	static function convertDifficulty(converted:ConvertedSong, parsed:Dynamic):SongDifficulty
	{
		var singers:Map<String, NoteChart>;

		var sectionTime:Float = 0.0; // Used to track when the section starts
		var playerChart:NoteChart;
		var opponentChart:NoteChart;
		var isPlayer:Bool;
		var newNote:Note;
		for (section in cast(parsed.song.notes, Array<Dynamic>))
		{
			if (section.changeBPM) // Add the BPM change to the map
				converted.instrumental.bpmMap.push({time: sectionTime, bpm: section.bpm});

			playerChart = new NoteChart([]);
			opponentChart = new NoteChart([]);
			isPlayer = section.mustHitSection; // Whether this is a player note
			for (note in cast(section.sectionNotes, Array<Dynamic>))
			{
				// Old FNF uses numbers past 3 to represent notes on the other side
				if (note[1] > 3)
				{
					isPlayer = !isPlayer;
					note[1] -= 4;
				}

				newNote = new Note(NoteTypeRegistry.getAsset(Note.DEFAULT_ID), note[0], note[1], note[2]);
				if (isPlayer)
					playerChart.nodes.push(newNote);
				else
					opponentChart.nodes.push(newNote);
			}

			sectionTime += section.lengthInSteps;
		}

		singers.set("player", playerChart);
		singers.set("opponent", opponentChart);
		return {singers: singers, scrollSpeed: parsed.speed};
	}
}

typedef ConvertedSong =
{
	song:Song,
	instrumentalPath:String,
	// Used primarily for BPM map and volume
	instrumental:MusicData,
	voicesPath:String,
	// Used for volume
	voices:SoundData
}
