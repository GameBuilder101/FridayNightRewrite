package editor.types;

import flixel.group.FlxSpriteGroup;

class ArrayEditor extends FlxSpriteGroup implements IEditor<Array<Dynamic>>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null)
	{
		super(x, y);
		this.onChanged = onChanged;
	}

	public function getValue():Array<Dynamic>
	{
		return null;
	}

	public function setValue(value:Array<Dynamic>) {}
}
