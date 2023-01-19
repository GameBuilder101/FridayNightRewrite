package editor.types;

import flixel.addons.text.FlxTextField;

class IntEditor extends FlxTextField implements IEditor<Int>
{
	public function new(x:Float, y:Float, width:Int)
	{
		super(x, y, width);
		textField.restrict = "0-9";
	}

	public function getValue():Int
	{
		return cast text;
	}
}
