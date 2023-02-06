package editor.types;

import assetManagement.LibraryManager;
import flash.events.Event;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxSpriteGroup;
import openfl.net.FileFilter;
import openfl.net.FileReference;

using StringTools;

class FilePathEditor extends FlxSpriteGroup implements IEditor<String>
{
	public var onChanged:Void->Void;

	var fileExtension:String;
	var type:FilePathEditorType;

	var value:StringEditor;
	var fileButton:FlxUIButton;

	public function new(x:Float, y:Float, width:Int, fileExtension:String, type:FilePathEditorType, onChanged:Void->Void = null)
	{
		super(x, y);
		this.onChanged = onChanged;
		this.fileExtension = fileExtension;
		this.type = type;

		value = new StringEditor(x, y, cast width * 0.8, function()
		{
			this.onChanged();
		});
		add(value);
		fileButton = new FlxUIButton(x + width * 0.8, y, "File", openFileDialog);
		fileButton.resize(width * 0.2, value.height);
		add(fileButton);
	}

	public function getValue():String
	{
		return value.getValue();
	}

	public function setValue(value:String)
	{
		this.value.setValue(value);
	}

	function openFileDialog()
	{
		var fileRef:FileReference = new FileReference();
		fileRef.addEventListener(Event.SELECT, onSelect, false, 0, true);
		fileRef.browse([new FileFilter("File", fileExtension)]);
	}

	function onSelect(event:Event)
	{
		var fileRef:FileReference = cast(event.target, FileReference);
		var path:String = stylePath(fileRef.name);
		if (path != null)
			value.text = path;
	}

	/** If this editor is for an asset ID, this shortens the path to something valid **/
	function stylePath(path:String):String
	{
		if (type == NORMAL) // If normal, then don't shorten the path
			return path;

		// Remove the file extension
		path = path.substring(0, path.lastIndexOf("."));

		if (type == EXCLUDE_EXTENSION)
			return path;

		// Remove the executable path part
		path = path.substring(Sys.programPath().length + 1, path.length);

		if (type == ASSET_ID_INCLUDE_LIBRARY)
			return path;

		// If it refers to the core library
		if (path.startsWith(LibraryManager.CORE_ID))
			return path.substring(LibraryManager.CORE_ID.length + 1, path.length);

		// Remove the mods directory
		path = path.substring(LibraryManager.MODS_DIRECTORY.length + 1, path.length);
		// Remove the library directory
		path = path.substring(path.indexOf("/") + 1, path.length);
		return path;
	}
}

enum FilePathEditorType
{
	NORMAL;
	EXCLUDE_EXTENSION;
	// Remove all parts of the path until after the library name
	ASSET_ID;
	// Remove all parts of the path until after the executable directory
	ASSET_ID_INCLUDE_LIBRARY;
}
