package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import music.Note;

class NoteChart extends Chart<Note>
{
	/** Converts from parsed JSON. **/
	public static function fromParsed(parsed:Dynamic):NoteChart
	{
		// Create the notes from the chart data
		var notes:Array<Note> = [];
		for (note in cast(parsed, Array<Dynamic>))
		{
			if (note.c == null) // If no type is provided, assume normal
				note.c = "assets/note_types/normal";
			notes.push(new Note(NoteTypeRegistry.getAsset(note.c), note.t, note.l));
		}

		return new NoteChart(notes);
	}
}
