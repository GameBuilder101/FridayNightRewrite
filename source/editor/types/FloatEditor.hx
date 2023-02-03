package editor.types;

import flixel.addons.ui.FlxUIInputText;

class FloatEditor extends FlxUIInputText implements IEditor<Float>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null)
	{
		super(x, y, width);
		callback = function(text:String, action:String)
		{
			onChanged();
		};
		textField.restrict = "0-9.";
	}

	public function getValue():Float
	{
		return cast text;
	}
}
