package editor.types;

import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import haxe.EnumTools;

/** Edits an enum using a dropdown with the ouput being the name of the selected item. **/
class EnumNameEditor extends FlxUIDropDownMenu implements IEditor<String>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, type:Enum<Dynamic>, onChanged:Void->Void = null)
	{
		this.onChanged = onChanged;

		// Add dropdown items based on the enum constructors
		var dataList:Array<StrNameLabel> = [];
		var constructors:Array<String> = EnumTools.getConstructors(type);
		for (constructor in constructors)
			dataList.push(new StrNameLabel(constructor, constructor));
		setData(dataList);

		super(x, y, dataList, function(name:String)
		{
			this.onChanged();
		});
	}

	public function getValue():String
	{
		return selectedId;
	}

	public function setValue(value:String)
	{
		selectedId = value;
	}
}
