package editor.types;

import flixel.addons.text.FlxTextField;

class FloatEditor extends FlxTextField implements IEditor<Float>
{
	public function new(x:Float, y:Float, width:Int)
	{
		super(x, y, width);
		textField.restrict = "0-9.";
	}

	public function getValue():Float
	{
		return cast text;
	}
}
