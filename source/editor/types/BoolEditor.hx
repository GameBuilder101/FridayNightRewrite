package editor.types;

import flixel.addons.ui.FlxUICheckBox;

class BoolEditor extends FlxUICheckBox implements IEditor<Bool>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null, label:String = null)
	{
		super(x, y, null, null, label, width, null, onChanged);
	}

	public function getValue():Bool
	{
		return checked;
	}

	public function setValue(value:Bool)
	{
		checked = value;
	}
}
