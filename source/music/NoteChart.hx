package music;

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
				note.c = Note.DEFAULT_ID;
			if (note.s == null)
				note.s = 0.0;
			notes.push(new Note(NoteTypeRegistry.getAsset(note.c), note.t, note.l, note.s));
		}
		return new NoteChart(notes);
	}
}
