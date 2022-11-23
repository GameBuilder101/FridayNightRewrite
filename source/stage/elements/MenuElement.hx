package stage.elements;

import flixel.util.FlxColor;
import menu.Menu;

class MenuElement extends Menu implements StageElement
{
	public function new(data:Dynamic)
	{
		super(0.0, 0.0);
		menuType = MenuType.createByName(data.type);

		normalItemColor = FlxColor.fromRGB(data.normalItemColor[0], data.normalItemColor[1], data.normalItemColor[2]);
		selectedItemColor = FlxColor.fromRGB(data.selectedItemColor[0], data.selectedItemColor[1], data.selectedItemColor[2]);
	}

	public function onAddedToStage(stage:Stage) {}
}
