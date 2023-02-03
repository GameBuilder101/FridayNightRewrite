package editor;

/** The fundemental editor interface. **/
interface IEditor<T>
{
	var onChanged:Void->Void;

	function getValue():T;

	function setValue(value:T):Void;

	/** Used for layout/spacing. Any flixel objects will have this function by default. **/
	function setPosition(x:Float, y:Float):Void;

	/** Used for layout/spacing. Any flixel objects will have this function by default.. **/
	function get_height():Float;
}
