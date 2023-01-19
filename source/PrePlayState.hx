package;

import Album;
import Character;
import DifficultyUtil;
import GlobalScript;
import Scores;
import Week;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menu.MenuItem;
import menu.MenuState;
import menu.items.FlashingButtonMenuItem;
import music.Conductor;
import music.MusicData;
import music.Song;
import stage.Stage;
import stage.elements.GeneralSpriteElement;

/** For stuff common between the week select and freeplay states. **/
abstract class PrePlayState extends MenuState
{
	public var albumID:String;

	/** The album that was selected in the album select state. **/
	public var album:AlbumData;

	/** The currently-selected difficulty index. **/
	var difficulty:Int = DifficultyUtil.DEFAULT_SELECTED;

	/** Used to update displayed information. **/
	var currentHighScore:HighScore;

	var difficultyText:SpriteText;
	var leftDifficultyArrow:AssetSprite;
	var rightDifficultyArrow:AssetSprite;

	var highScoreText:FlxText;

	var fullComboBadge:AssetSprite;
	var ghostFullComboBadge:AssetSprite;

	override function create()
	{
		super.create();

		// Add difficulty selection sprites
		difficultyText = new SpriteText(0.0, 0.0, "", 0.75, CENTER, true);
		add(difficultyText);

		leftDifficultyArrow = new AssetSprite(0.0, 0.0, "menus/_shared/arrow");
		leftDifficultyArrow.flipX = true;
		leftDifficultyArrow.offset.set(leftDifficultyArrow.width, 0.0);
		add(leftDifficultyArrow);

		rightDifficultyArrow = new AssetSprite(0.0, 0.0, "menus/_shared/arrow");
		add(rightDifficultyArrow);

		// Add high score text
		highScoreText = new FlxText(0.0, 0.0, 100);
		highScoreText.setFormat("Jann Script Bold", 24, FlxColor.WHITE, CENTER);
		highScoreText.alpha = 0.75;
		add(highScoreText);

		fullComboBadge = cast stage.getElementWithTag("full_combo_badge");
		fullComboBadge.visible = true;
		ghostFullComboBadge = cast stage.getElementWithTag("ghost_full_combo_badge");
		ghostFullComboBadge.visible = false;

		// Update the background and music to the album background/music
		Conductor.play(MusicDataRegistry.getAsset(album.menuMusicID), true, false);
		background.loadFromID(album.backgroundID);
		background.color = album.backgroundColor;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (currentHighScore != null)
			highScoreText.text = "High Score: " + currentHighScore.score;
		else
			highScoreText.text = "No high score";
		ghostFullComboBadge.visible = currentHighScore != null && currentHighScore.fullCombo && currentHighScore.ghostTapping;
		fullComboBadge.visible = currentHighScore != null && currentHighScore.fullCombo && !ghostFullComboBadge.visible;

		if (menu.interactable)
		{
			// Go back to the main menu if the back button is pressed
			if (Controls.cancel.check())
			{
				menu.playCancelSound();
				FlxG.switchState(new TitleScreenState());
			}

			// Difficulty selection
			if (Controls.uiLeft.check())
			{
				difficulty--;
				if (difficulty < 0)
					difficulty = DifficultyUtil.getMax() - 1;
				selectDifficulty(difficulty);
				menu.playToggleSound();
			}
			else if (Controls.uiRight.check())
			{
				difficulty++;
				if (difficulty >= DifficultyUtil.getMax())
					difficulty = 0;
				selectDifficulty(difficulty);
				menu.playToggleSound();
			}
		}
	}

	/** Returns a color to use for an opponent. **/
	public static function getOpponentThemeColor(opponentID:String):FlxColor
	{
		if (opponentID == null)
			return Settings.getPlayerCharacter().themeColor;
		return CharacterDataRegistry.getAsset(opponentID).themeColor;
	}

	/** Sets the difficulty and updates sprite graphics. **/
	function selectDifficulty(index:Int)
	{
		difficulty = index;
		var data:Difficulty = DifficultyUtil.BUILTIN[index];

		difficultyText.setText(data.name);
		difficultyText.color = data.color;

		leftDifficultyArrow.x = difficultyText.x - difficultyText.members[0].offset.x - 16.0;
		leftDifficultyArrow.color = data.color;
		rightDifficultyArrow.x = difficultyText.x - difficultyText.members[0].offset.x + difficultyText.width + 16.0;
		rightDifficultyArrow.color = data.color;

		fullComboBadge.color = data.color;

		menu.selectedItemColor = data.color;
	}

	function prePlayTransition(state:FlxState)
	{
		specialTransition(state);
		Conductor.fadeOut(0.8);
	}
}
