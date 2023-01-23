package editor.types;

import flixel.addons.ui.FlxUICheckBox;

class BoolEditor extends FlxUICheckBox implements IEditor<Bool>
{
	public function new(x:Float, y:Float, width:Int, label:String)
	{
		super(x, y, null, null, label, width);
	}

	public function getValue():Bool
	{
		return checked;
	}
}
