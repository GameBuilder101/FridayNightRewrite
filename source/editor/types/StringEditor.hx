package editor.types;

import flixel.addons.ui.FlxUIInputText;

class StringEditor extends FlxUIInputText implements IEditor<String>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null)
	{
		super(x, y, width);
		this.onChanged = onChanged;
		callback = function(text:String, action:String)
		{
			this.onChanged();
		};
	}

	public function getValue():String
	{
		return text;
	}

	public function setValue(value:String)
	{
		text = value;
	}
}
