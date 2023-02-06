package editor.states;

import AssetSprite;
import assetManagement.FileManager;
import editor.types.advanced.AssetSpriteEditor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.util.FlxColor;
import haxe.Json;
import stage.Stage;

class AssetSpriteEditorState extends ConductedState
{
	var mainEditor:AssetSpriteEditor;
	var saveButton:FlxUIButton;

	var pivot:FlxSprite;
	var spritePreview:AssetSprite;

	override function create()
	{
		super.create();
		mainEditor = new AssetSpriteEditor(16.0, 16.0, cast(FlxG.width / 2.0 - 32.0));
		saveButton = new FlxUIButton(16.0, FlxG.height - 16.0, "Save", function()
		{
			trace("test");
		});

		pivot = new FlxSprite(FlxG.width * 0.75, FlxG.height / 2.0).makeGraphic(16, 16, FlxColor.MAGENTA);
		pivot.offset.set(8.0, 8.0);

		spritePreview = new AssetSprite(pivot.x, pivot.y);

		add(spritePreview);
		add(pivot);
		add(mainEditor);
		add(saveButton);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Controls.cancel.check())
			FlxG.switchState(new EditorSelectState());
	}

	function createStage():Stage
	{
		return null;
	}

	function onChanged()
	{
		var value:Dynamic = mainEditor.getValue();
		var previewData:AssetSpriteData = {
			graphic: FileManager.getGraphic(value.graphic),
			sparrowAtlas: FileManager.getXML(value.sparrowAtlas),
			spriteSheetPacker: FileManager.getText(value.spriteSheetPacker),
			flipX: value.flipX,
			flipY: value.flipY,
			animations: value.animations,
			defaultAnim: value.defaultAnim,
			antialiasing: value.antialiasing,
			color: FlxColor.fromRGB(value.color[0], value.color[1], value.color[2]),
			alpha: value.alpha,
			blend: value.blend,
			shaderType: value.shaderType,
			shaderArgs: Json.parse(value.shaderArgs)
		}
	}
}
