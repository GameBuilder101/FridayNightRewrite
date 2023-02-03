package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;

class Song
{
	/** The song name. **/
	public var name:String;

	public var credits:String;

	public var stageID:String;
	public var opponentID:String;

	public var playerVariant:String;
	public var opponentVariant:String;
	public var girlfriendVariant:String;

	/** Each index of the array corresponds to a difficulty index. If the element is
		null, that means this song doesn't have a chart for that difficulty. Each singer
		map has a string as a key. This string represents the tag of the character who
		sings that chart (IE: "player", "opponent", "girlfriend", etc.)
	**/
	public var difficulties:Array<SongDifficulty>;

	public var instrumentalID:String;
	public var voicesID:String;

	public function new(name:String, credits:String = "")
	{
		this.name = name;
		this.credits = credits;
		// Fill out charts with null
		for (i in 0...DifficultyUtil.getMax())
			difficulties.push(null);
	}

	public function getChart(characterTag:String, difficulty:Int):NoteChart
	{
		var i:Int = difficulty;
		/* Start by searching to the right of the given difficulty. If there
			is a chart for this difficulty, it gets returned. If not, it returns the next
			highest difficulty which has a chart. */
		while (i < difficulties.length)
		{
			if (difficulties[i] != null)
				return difficulties[i].singers[characterTag];
			i++;
		}
		// Now search to the left if there isn't a higher difficulty to replace
		i = difficulty;
		while (i >= 0)
		{
			if (difficulties[i] != null)
				return difficulties[i].singers[characterTag];
			i--;
		}
		return null;
	}
}

typedef SongDifficulty =
{
	singers:Map<String, NoteChart>,
	scrollSpeed:Float
}

/** Use this to access/load songs. **/
class SongRegistry extends Registry<Song>
{
	static var cache:SongRegistry = new SongRegistry();
	static var cachedIDs:Array<String>;

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
			cachedIDs = [];
		});
	}

	function loadData(directory:String, id:String):Song
	{
		var path:String = Registry.getFullPath(directory, id);
		var parsed:Dynamic = FileManager.getParsedJson(path + "/song_data");
		if (parsed == null)
			return null;

		var song:Song = new Song(parsed.name, parsed.credits);
		song.stageID = parsed.stageID;
		song.opponentID = parsed.opponentID;
		song.playerVariant = parsed.playerVariant;
		song.opponentVariant = parsed.opponentVariant;
		song.girlfriendVariant = parsed.girlfriendVariant;

		song.instrumentalID = path + "/instrumental";
		song.voicesID = path + "/voices";

		/* Song charts are loaded in dynamically. Loop through all files with the naming convention "difficulty_#" until
			no more are found. These will contain the charts corresponding to the difficulties of the song */
		var difficulties:Array<SongDifficulty> = [];
		var parsedDiff:Dynamic;
		var singers:Map<String, NoteChart>;
		var i:Int = 0;
		while (true)
		{
			parsedDiff = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/difficulty_" + i);
			if (parsedDiff == null)
				break;
			singers = new Map<String, NoteChart>();
			for (singer in cast(parsedDiff.singers, Array<Dynamic>))
				singers.set(singer.key, NoteChart.fromParsed(singer.chart));
			i++;
		}
		song.difficulties = difficulties;

		return song;
	}

	public static function getAsset(id:String):Song
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("songs");
		return cachedIDs;
	}
}
