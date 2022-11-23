package;

import assetManagement.LibraryManager;
import assetManagement.ParsedJSONRegistry;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import music.ConductedState;
import music.Conductor;
import music.MusicData;
import stage.Stage;

class TitleScreenState extends ConductedState
{
	/** The title screen data obtained from a JSON. **/
	var data:Dynamic;

	var playingIntro:Bool;

	/** The randomized flavor text used in the intro. **/
	var introComment:Array<String>;

	public static var playedIntro(default, null):Bool;

	var introDarken:FlxSprite;
	var introLines:Array<SpriteText> = new Array<SpriteText>();

	/** The Newgrounds logo used in the intro. **/
	var newgroundsLogo:AssetSprite;

	var versionText:FlxText;

	override public function create()
	{
		super.create();
		data = ParsedJSONRegistry.getAsset("menus/title_screen/title_screen_data");

		Conductor.play(MusicRegistry.getAsset(data.musicID), true);
		Conductor.fadeIn(0.5);

		introDarken = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		introDarken.visible = false;
		add(introDarken);

		// Create the intro lines (which will get re-used for multiple intro things)
		for (i in 0...5)
		{
			introLines.push(new SpriteText(FlxG.width / 2.0, FlxG.height / 2.0 - (2.5 - i) * 64.0, "", 0.9, CENTER, true));
			add(introLines[introLines.length - 1]);
		}

		newgroundsLogo = new AssetSprite(0.0, 0.0, "menus/title_screen/newgrounds_logo");
		newgroundsLogo.scale.set(0.8, 0.8);
		newgroundsLogo.updateHitbox();
		newgroundsLogo.screenCenter();
		newgroundsLogo.y += 170.0;
		newgroundsLogo.visible = false;
		add(newgroundsLogo);

		versionText = new FlxText(16.0, 16.0, FlxG.width - 32.0, "Friday Night Rewrite v" + LibraryManager.getCore().version);
		versionText.setFormat("Jann Script Bold", 14, FlxColor.WHITE, RIGHT);
		versionText.alpha = 0.4;
		add(versionText);

		if (!playedIntro)
			playIntro();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
			skipIntro();
	}

	function createStage():Stage
	{
		return new Stage("menus/title_screen");
	}

	function playIntro()
	{
		if (playingIntro)
			return;
		playingIntro = true;

		// Obtain a random flavor text comment to be used in the intro
		var comments:Array<Dynamic> = cast(data.introComments, Array<Dynamic>);
		introComment = comments[FlxG.random.int(0, comments.length - 1)];

		introDarken.visible = true;
	}

	function skipIntro()
	{
		if (!playingIntro)
			return;
		Conductor.setTime(Conductor.currentMusic.getTimeAt(16.0));
		endIntro();
	}

	function endIntro()
	{
		playingIntro = false;
		playedIntro = true;

		resetIntroLines();
		introDarken.visible = false;
		newgroundsLogo.visible = false;

		FlxG.cameras.flash();
	}

	override function onWholeBeat(beat:Int)
	{
		super.onWholeBeat(beat);
		if (!playingIntro)
			return;

		// Play the intro stuff each beat
		switch (beat)
		{
			case 1:
				displayIntroLine(0, "ninjamuffin99");
				displayIntroLine(1, "PhantomArcade");
				displayIntroLine(2, "KawaiSprite");
				displayIntroLine(3, "evilsk8r");
			case 3:
				displayIntroLine(4, "present");
			case 4:
				resetIntroLines();
			case 5:
				displayIntroLine(0, "in association");
				displayIntroLine(1, "with");
			case 7:
				displayIntroLine(2, "Newgrounds");
				newgroundsLogo.visible = true;
			case 8:
				resetIntroLines();
				newgroundsLogo.visible = false;
			case 9:
				displayIntroLine(1, introComment[0]);
			case 11:
				displayIntroLine(2, introComment[1]);
			case 12:
				resetIntroLines();
			case 13:
				displayIntroLine(1, "Friday");
			case 14:
				displayIntroLine(2, "Night");
			case 15:
				displayIntroLine(3, "Funkin'");
			case 16:
				endIntro();
		}
	}

	function displayIntroLine(index:Int, text:String)
	{
		introLines[index].setText(text);
		introLines[index].visible = true;
	}

	function resetIntroLines()
	{
		for (introLine in introLines)
			introLine.visible = false;
	}
}
