package music;

import assetManagement.FileManager;

using StringTools;

class OldSongConverter
{
	/** Attempts to convert an old FNF song to the new format. Not guaranteed to work for
		everything.
		@param path The file path to the folder containing all difficulties.
	**/
	public static function convert(path:String):Song
	{
		var songID:String = path.substring(path.lastIndexOf("/") + 1, path.length);
		// Get the parsed JSON data for each difficulty
		var easy:Dynamic = FileManager.getParsedJson(path + "/" + songID + "-easy");
		var normal:Dynamic = FileManager.getParsedJson(path + "/" + songID);
		var hard:Dynamic = FileManager.getParsedJson(path + "/" + songID + "-hard");
		if (easy == null && normal == null && hard == null)
			return null;

		// Set up the converted song
		var song:Song = new Song(normal.song.song);
		song.opponentID = playerIDToCharacterID(normal.song.player2);
		song.playerVariant = playerIDToVariantID(normal.song.player1);
		song.opponentVariant = playerIDToVariantID(normal.song.player2);
		if (easy != null)
			song.charts[0] = convertChart(easy);
		if (normal != null)
			song.charts[1] = convertChart(normal);
		if (hard != null)
			song.charts[2] = convertChart(hard);

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
		if (player.endsWith("-car"))
			return "car";
		else if (player.endsWith("-christmas"))
			return "christmas";
		else if (player.endsWith("-pixel"))
			return "pixel";
		else if (player.endsWith("-angry"))
			return "angry";
		return "normal";
	}

	/** Converts the charts from an old song into charts for a new song. **/
	static function convertChart(parsed:Dynamic):Map<String, NoteChart>
	{
		var map:Map<String, NoteChart>;
		var playerChart:NoteChart = new NoteChart([]);
		var opponentChart:NoteChart = new NoteChart([]);

		for (section in cast(parsed.song.notes, Array<Dynamic>)) {}

		map.set("player", playerChart);
		map.set("opponent", opponentChart);
		return map;
	}
}
