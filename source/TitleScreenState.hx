package;

import AssetSprite;
import assetManagement.ParsedJSONRegistry;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import menu.Menu;
import menu.items.FlashingButtonMenuItem;
import music.ConductedState;
import music.Conductor;
import music.MusicData;
import stage.Stage;

class TitleScreenState extends ConductedState
{
	/** The title screen data obtained from a JSON. **/
	var data:Dynamic;

	var menu:Menu;

	var versionText:FlxText;

	var playingIntro:Bool;
	var introBeats:Array<Dynamic>;

	/** The randomized flavor text used in the intro. **/
	var introFlavorText:Array<String>;

	public static var playedIntro(default, null):Bool;

	var introDarken:FlxSprite;
	var introLines:Array<SpriteText> = new Array<SpriteText>();

	/** Used for things such as the Newgrounds logo in the intro. **/
	var introImage:AssetSprite;

	var outdatedWarning:FlxSpriteGroup;

	override public function create()
	{
		super.create();
		data = ParsedJSONRegistry.getAsset("menus/title_screen/title_screen_data");

		introBeats = cast(data.introBeats, Array<Dynamic>);

		// Get the main menu and add the menu options
		var menus:Array<FlxSprite> = stage.getElementsWithTag("menu");
		if (menus.length > 0)
		{
			menu = cast menus[menus.length - 1];
			menu.createItems([
				{
					type: FlashingButtonMenuItem,
					label: "Story Mode",
					iconID: null,
					onSelected: null,
					onInteracted: function(data:Dynamic)
					{
						transition(new PlayState());
					}
				},
				{
					type: FlashingButtonMenuItem,
					label: "Freeplay",
					iconID: null,
					onSelected: null,
					onInteracted: null
				},
				#if ENABLE_CHARACTER_SELECT
				{
					type: FlashingButtonMenuItem,
					label: "Character",
					iconID: null,
					onSelected: null,
					onInteracted: null
				},
				#end
				#if ENABLE_ACHIEVEMENTS
				{
					type: FlashingButtonMenuItem,
					label: "Awards",
					iconID: null,
					onSelected: null,
					onInteracted: null
				},
				#end
				#if ENABLE_MODS
				{
					type: FlashingButtonMenuItem,
					label: "Mods",
					iconID: null,
					onSelected: null,
					onInteracted: null
				},
				#end
				{
					type: FlashingButtonMenuItem,
					label: "Settings",
					iconID: null,
					onSelected: null,
					onInteracted: null
				}
			]);
		}

		// Add the engine version text
		versionText = new FlxText(16.0, 16.0, FlxG.width - 32.0, "Friday Night Rewrite v" + Main.currentVersion);
		versionText.setFormat("Jann Script Bold", 14, FlxColor.WHITE, RIGHT);
		versionText.alpha = 0.4;
		add(versionText);

		introDarken = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(introDarken);
		introDarken.kill();

		// Create the intro lines (which will get re-used for multiple intro things)
		for (i in 0...5)
		{
			introLines.push(new SpriteText(FlxG.width / 2.0, FlxG.height / 2.0 - (2.5 - i) * 64.0, "", 0.9, CENTER, true));
			add(introLines[introLines.length - 1]);
			introLines[introLines.length - 1].kill();
		}

		// Add the newgrounds logo for the intro
		introImage = new AssetSprite(0.0, 0.0);
		introImage.scale.set(0.8, 0.8);
		add(introImage);
		introImage.kill();

		outdatedWarning = new FlxSpriteGroup();
		var outdatedBack:FlxSprite = new FlxSprite().makeGraphic(512, 170, FlxColor.BLACK);
		outdatedBack.alpha = 0.6;
		outdatedWarning.add(outdatedBack);
		var outdatedTitle:FlxText = new FlxText(16.0, 16.0, 480.0, "WARNING: YOU ARE USING AN OUTDATED VERSION OF FRIDAY NIGHT REWRITE!");
		outdatedTitle.setFormat("Jann Script Bold", 17, FlxColor.RED);
		outdatedWarning.add(outdatedTitle);
		var outdatedVersion:FlxText = new FlxText(16.0, 80.0, 480.0, "Your version: " + Main.currentVersion + "    Latest version: " + Main.latestVersion);
		outdatedVersion.setFormat("Jann Script Bold", 14, FlxColor.GRAY);
		outdatedWarning.add(outdatedVersion);
		var outdatedDownload:FlxText = new FlxText(16.0, 110.0, 480.0, "Press 'U' to download the latest version!");
		outdatedDownload.setFormat("Jann Script Bold", 14);
		outdatedWarning.add(outdatedDownload);
		add(outdatedWarning);
		outdatedWarning.kill();

		Conductor.play(MusicRegistry.getAsset(data.musicID), true);
		Conductor.fadeIn(0.5);

		if (!playedIntro)
			playIntro();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if ENABLE_OUTDATED_WARNING
		if (Main.outdated)
		{
			if (FlxG.keys.justPressed.U)
				FlxG.openURL("https://github.com/GameBuilder101/FridayNightRewrite/releases");

			// Show the outdated warning if outdated
			if (!outdatedWarning.exists)
				outdatedWarning.revive();
		}
		#end

		if (FlxG.keys.justPressed.ENTER)
			skipIntro();
	}

	function createStage():Stage
	{
		return new Stage("menus/title_screen");
	}

	function transition(state:FlxState)
	{
		menu.interactable = false;
		new FlxTimer().start(0.8, function(timer:FlxTimer)
		{
			FlxG.switchState(state);
		});
	}

	public function playIntro()
	{
		if (playingIntro)
			return;
		playingIntro = true;
		menu.interactable = false;

		// Obtain a random flavor text comment to be used in the intro
		var allFlavorText:Array<Dynamic> = cast(data.introFlavorText, Array<Dynamic>);
		introFlavorText = allFlavorText[FlxG.random.int(0, allFlavorText.length - 1)];

		introDarken.revive();
	}

	public function skipIntro()
	{
		if (!playingIntro)
			return;
		// Jump to the ending beat
		Conductor.setTime(Conductor.currentMusic.getTimeAt(introBeats[introBeats.length - 1].beat));
		endIntro();
	}

	function endIntro()
	{
		playingIntro = false;
		playedIntro = true;
		menu.interactable = true;

		introClear();
		introDarken.kill();

		FlxG.cameras.flash();
	}

	override function onWholeBeat(beat:Int)
	{
		super.onWholeBeat(beat);
		if (!playingIntro)
			return;

		// Play the intro stuff each beat
		for (introBeat in introBeats)
		{
			// Only play the intro-beat if it should on this beat
			if (introBeat.beat != beat)
				continue;

			if (introBeat.line0 != null)
				displayIntroLine(0, introBeat.line0);
			if (introBeat.line1 != null)
				displayIntroLine(1, introBeat.line1);
			if (introBeat.line2 != null)
				displayIntroLine(2, introBeat.line2);
			if (introBeat.line3 != null)
				displayIntroLine(3, introBeat.line3);

			if (introBeat.flavorTextLine0 != null)
				displayIntroLine(introBeat.flavorTextLine0, introFlavorText[0]);
			if (introBeat.flavorTextLine1 != null)
				displayIntroLine(introBeat.flavorTextLine1, introFlavorText[1]);
			if (introBeat.displayImageID != null)
				displayIntroImage(introBeat.displayImageID);

			if (introBeat.clear != null && introBeat.clear)
				introClear();

			if (introBeat.end != null && introBeat.end)
				endIntro();
		}
	}

	function displayIntroLine(index:Int, text:String)
	{
		introLines[index].revive();
		introLines[index].setText(text);
	}

	function introClear()
	{
		for (introLine in introLines)
			introLine.kill();
		introImage.kill();
	}

	function displayIntroImage(id:String)
	{
		introImage.loadFromData(AssetSpriteRegistry.getAsset(id));
		introImage.updateHitbox();
		introImage.screenCenter();
		introImage.y += 170.0;
		introImage.revive();
	}
}
