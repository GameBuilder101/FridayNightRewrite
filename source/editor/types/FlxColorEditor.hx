package editor.types;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class FlxColorEditor extends FlxSpriteGroup implements IEditor<Array<Int>>
{
	public var onChanged:Void->Void;

	var r:IntEditor;
	var g:IntEditor;
	var b:IntEditor;
	var preview:FlxSprite;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null)
	{
		super(x, y);
		r = new IntEditor(x, y, cast width / 3.0, onChanged);
		add(r);
		g = new IntEditor(x + width / 3.0, y, cast width / 3.0, onChanged);
		add(g);
		b = new IntEditor(x + width / 3.0 * 2.0, y, cast width / 3.0, onChanged);
		add(b);
		preview = new FlxSprite(width, y).makeGraphic(cast r.height, cast r.height, FlxColor.WHITE);
		add(preview);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		preview.color = FlxColor.fromRGB(r.getValue(), g.getValue(), b.getValue());
	}

	public function getValue():Array<Int>
	{
		return [r.getValue(), g.getValue(), b.getValue()];
	}
}
