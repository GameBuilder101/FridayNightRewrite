package editor.types;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class DynamicEditor extends FlxSpriteGroup implements IEditor<Dynamic>
{
	var label:FlxText;
	var back:FlxSprite;

	var editors:Array<IEdtior<Dynamic>> = [];

	public function new(x:Float, y:Float, width:Int, fields:Array<IEditor<Dynamic>>, label:String)
	{
		super(x, y);
		back = new FlxSprite(x, y);
		add(back);

		label = new FlxText(x, y - 16.0, width, label);
		add(label);

		var editorY:Float = y;
		for (field in fields)
		{
			editorY += field.height;
		}
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
