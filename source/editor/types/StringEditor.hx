package editor.types;

import flixel.addons.text.FlxTextField;

class StringEditor extends FlxTextField implements IEditor<String>
{
	public function new(x:Float, y:Float, width:Int)
	{
		super(x, y, width);
	}

	public function getValue():String
	{
		return text;
	}
}
