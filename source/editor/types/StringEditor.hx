package editor.types;

import flixel.addons.ui.FlxUIInputText;

class StringEditor extends FlxUIInputText implements IEditor<String>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null)
	{
		super(x, y, width);
		callback = function(text:String, action:String)
		{
			onChanged();
		};
	}

	public function getValue():String
	{
		return text;
	}
}
