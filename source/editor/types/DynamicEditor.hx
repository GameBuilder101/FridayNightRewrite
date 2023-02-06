package editor.types;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

abstract class DynamicEditor extends FlxSpriteGroup implements IEditor<Dynamic>
{
	public static final ITEM_SPACING:Float = 16.0;

	public var onChanged:Void->Void;

	var back:FlxSprite;

	var editors:Map<String, IEditor<Dynamic>> = new Map<String, IEditor<Dynamic>>();

	public function new(x:Float, y:Float, width:Int, onChanged:Void->Void = null)
	{
		super(x, y);
		this.onChanged = onChanged;

		back = new FlxSprite(x, y);
		back.alpha = 0.6;
		add(back);

		editors = getEditors(x + ITEM_SPACING, width - cast(ITEM_SPACING * 2.0));

		// Position the editors and create the background sprite
		var yTracker:Float = ITEM_SPACING;
		for (editor in editors)
		{
			editor.setPosition(x, yTracker);
			add(cast editor);
			yTracker += editor.get_height() + ITEM_SPACING;
		}
		back.makeGraphic(width, cast yTracker, FlxColor.BLACK);
	}

	/** Return a map containing all the editors for this dynamic. Each key should correspond
		directly to the name of a field in the dynamic. Note: positions will get automatically set.
	**/
	abstract function getEditors(x:Float, width:Int):Map<String, IEditor<Dynamic>>;

	public function getValue():Dynamic
	{
		var value:Dynamic = {};
		for (editor in editors.keyValueIterator())
			value.setField(editor.key, editor.value.getValue());
		return value;
	}

	public function setValue(value:Dynamic)
	{
		for (field in Reflect.fields(value))
			editors[field].setValue(value.getField(field));
	}
}
