package;

import assetManagement.FileManager;
import music.ConductedState;
import music.MusicData;
import stage.Stage;

class TitleScreenState extends ConductedState
{
	/** The title screen data obtained from a JSON. **/
	var data:Dynamic;

	var stage:Stage;

	override public function create()
	{
		super.create();
		data = FileManager.getParsedJson("assets/menus/title_screen/title_screen_data");

		conductor.play(MusicRegistry.getAsset(data.musicID), true);

		stage = new Stage("menus/title_screen");
		add(stage);
	}
}
