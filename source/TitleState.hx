package;

import music.ConductedState;
import stage.Stage;

class TitleState extends ConductedState
{
	var stage:Stage;

	override public function create()
	{
		super.create();
		stage = new Stage("menus/title_screen");
	}
}
