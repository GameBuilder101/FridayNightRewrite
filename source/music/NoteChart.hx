package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import music.Note;

class NoteChart extends Chart<Note> {}

/** Use this to access/load note charts. **/
class NoteChartRegistry extends Registry<NoteChart>
{
	static var cache:NoteChartRegistry = new NoteChartRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
		});
	}

	function loadData(directory:String, id:String):NoteChart
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id));
		if (parsed == null)
			return null;

		// Create the notes from the chart data provided in the file
		var notes:Array<Note> = [];
		for (note in cast(parsed, Array<Dynamic>))
		{
			if (note.c == null) // If no type is provided, assume normal
				note.c = "assets/note_types/normal";
			notes.push(new Note(NoteTypeRegistry.getAsset(note.c), note.t, note.l));
		}

		return new NoteChart(notes);
	}

	public static function getAsset(id:String):NoteChart
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
