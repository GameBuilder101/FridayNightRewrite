package stage.elements;

import SoundData;
import flixel.util.FlxColor;
import menu.Menu;

/** A menu element only defines the look of a menu. The options of a menu are hard-coded and defined by the corresponding menu state. **/
class MenuElement extends Menu implements IStageElement
{
	public function new(data:Dynamic)
	{
		super(0.0, 0.0, MenuType.createByName(data.type));

		spacing = data.spacing;
		if (data.radius != null)
			radius = data.radius;

		if (data.fontSize != null)
			fontSize = data.fontSize;
		if (data.waveSelectedItem != null)
			waveSelectedItem = data.waveSelectedItem;

		if (data.normalItemColor != null)
			normalItemColor = FlxColor.fromRGB(data.normalItemColor[0], data.normalItemColor[1], data.normalItemColor[2]);
		if (data.selectedItemColor != null)
			selectedItemColor = FlxColor.fromRGB(data.selectedItemColor[0], data.selectedItemColor[1], data.selectedItemColor[2]);
		if (data.disabledItemColor != null)
			disabledItemColor = FlxColor.fromRGB(data.disabledItemColor[0], data.disabledItemColor[1], data.disabledItemColor[2]);
		if (data.minimumAlpha != null)
			minimumAlpha = data.minimumAlpha;

		if (data.selectSoundID != null)
			selectSound = SoundDataRegistry.getAsset(data.selectSoundID);
		if (data.confirmSoundID != null)
			confirmSound = SoundDataRegistry.getAsset(data.confirmSoundID);
		if (data.cancelSoundID != null)
			cancelSound = SoundDataRegistry.getAsset(data.cancelSoundID);
		if (data.errorSoundID != null)
			errorSound = SoundDataRegistry.getAsset(data.errorSoundID);
		if (data.toggleSoundID != null)
			toggleSound = SoundDataRegistry.getAsset(data.toggleSoundID);
	}

	public function onAddedToStage(stage:Stage)
	{
		this.stage = stage;
	}
}
