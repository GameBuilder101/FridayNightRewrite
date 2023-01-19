package editor.types;

import flixel.addons.ui.FlxUICheckBox;

class BoolEditor extends FlxUICheckBox implements IEditor<Bool>
{
	public function new(x:Float, y:Float, width:Int)
	{
		super(x, y, width);
	}

	public function getValue():Bool
	{
		return checked;
	}
}
