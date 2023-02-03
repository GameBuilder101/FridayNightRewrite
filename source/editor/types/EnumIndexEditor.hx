package editor.types;

import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import haxe.EnumTools;

/** Edits an enum using a dropdown with the ouput being the index of the selected item. **/
class EnumIndexEditor extends FlxUIDropDownMenu implements IEditor<Int>
{
	public var onChanged:Void->Void;

	var constructors:Array<String> = [];

	public function new(x:Float, y:Float, width:Int, type:Enum<Dynamic>, onChanged:Void->Void = null)
	{
		this.onChanged = onChanged;

		// Add dropdown items based on the enum constructors
		var dataList:Array<StrNameLabel> = [];
		constructors = EnumTools.getConstructors(type);
		for (constructor in constructors)
			dataList.push(new StrNameLabel(constructor, constructor));
		setData(dataList);

		super(x, y, dataList, function(name:String)
		{
			this.onChanged();
		});
	}

	public function getValue():Int
	{
		for (i in 0...constructors.length)
		{
			if (constructors[i] == selectedId)
				return i;
		}
		return 0;
	}

	public function setValue(value:Int)
	{
		selectedId = constructors[value];
	}
}
