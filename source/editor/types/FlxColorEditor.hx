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
	var a:IntEditor;
	var preview:FlxSprite;

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null, useAlpha:Bool = false)
	{
		super(x, y);
		this.onChanged = onChanged;

		r = new IntEditor(x, y, cast width / 3.0, function()
		{
			this.onChanged();
		});
		add(r);
		g = new IntEditor(x + width / 3.0, y, cast width / 3.0, function()
		{
			this.onChanged();
		});
		add(g);
		b = new IntEditor(x + width / 3.0 * 2.0, y, cast width / 3.0, function()
		{
			this.onChanged();
		});
		add(b);
		if (useAlpha)
		{
			a = new IntEditor(x + width, y, cast width / 3.0, function()
			{
				this.onChanged();
			});
			add(a);
		}
		preview = new FlxSprite(width, y).makeGraphic(cast r.height, cast r.height, FlxColor.WHITE);
		add(preview);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (a != null)
			preview.color = FlxColor.fromRGB(r.getValue(), g.getValue(), b.getValue(), a.getValue());
		else
			preview.color = FlxColor.fromRGB(r.getValue(), g.getValue(), b.getValue());
	}

	public function getValue():Array<Int>
	{
		if (a != null)
			return [r.getValue(), g.getValue(), b.getValue(), a.getValue()];
		return [r.getValue(), g.getValue(), b.getValue()];
	}

	public function setValue(value:Array<Int>)
	{
		r.setValue(value[0]);
		g.setValue(value[1]);
		b.setValue(value[2]);
		if (a != null)
			a.setValue(value[3]);
	}
}
