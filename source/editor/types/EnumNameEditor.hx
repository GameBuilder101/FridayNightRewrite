package editor.types;

import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import haxe.EnumTools;

class EnumNameEditor extends FlxUIDropDownMenu implements IEditor<String>
{
	public var onChanged:Void->Void;

	public function new(x:Float, y:Float, width:Int, type:Enum<Dynamic>, onChanged:Void->Void = null)
	{
		// Add dropdown items based on the enum constructors
		var dataList:Array<StrNameLabel> = [];
		var constructors:Array<String> = EnumTools.getConstructors(type);
		for (constructor in constructors)
			dataList.push(new StrNameLabel(constructor, constructor));
		setData(dataList);

		super(x, y, dataList, function(name:String)
		{
			onChanged();
		});
	}

	public function getValue():String
	{
		return selectedId;
	}
}
