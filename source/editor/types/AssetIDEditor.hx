package editor.types;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class AssetIDEditor extends FlxSpriteGroup implements IEditor<String>
{
	var value:String;

	var valueEditor:StringEditor;
	var fileButton:FlxButton;

	public function new(x:Float, y:Float, width:Int)
	{
		super(x, y);
		valueEditor = new StringEditor(x, y, width * 0.8);
		add(valueEditor);
		fileButton = new FlxButton(x + width * 0.8, y, "File");
		fileButton.width = width * 0.2;
		add(fileButton);
	}

	public function getValue():String
	{
		return value;
	}
}
