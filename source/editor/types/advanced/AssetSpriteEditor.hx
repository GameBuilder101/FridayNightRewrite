package editor.types.advanced;

class AssetSpriteEditor extends DynamicEditor
{
	function getEditors(x:Float, width:Int):Map<String, IEditor<Dynamic>>
	{
		var editors:Map<String, IEditor<Dynamic>> = new Map<String, IEditor<Dynamic>>();
		editors.set("graphic", new FilePathEditor(x, y, width, ".png", EXCLUDE_EXTENSION, function()
		{
			onChanged();
		}));
		return editors;
	}
}
