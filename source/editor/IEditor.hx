package editor;

/** The fundemental editor interface. **/
interface IEditor<T>
{
	var onChanged:Void->Void;

	function getValue():T;
}
