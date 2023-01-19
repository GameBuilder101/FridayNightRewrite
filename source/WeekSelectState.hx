package;

import Character;
import GlobalScript;
import Scores;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menu.MenuItem;
import menu.items.FlashingButtonMenuItem;
import music.Song;
import stage.Stage;
import stage.elements.GeneralSpriteElement;

class WeekSelectState extends PrePlayState
{
	var songListLabel:FlxText;
	var songListText:FlxText;

	var stagePreview:AssetSprite;
	var player:GeneralSpriteElement;
	var opponent:GeneralSpriteElement;
	var girlfriend:GeneralSpriteElement;

	var colorSplitPlayer:Array<AssetSprite> = [];
	var colorSplitOpponent:Array<AssetSprite> = [];

	override function create()
	{
		super.create();

		// Update PrePlayState elements
		difficultyText.setPosition(1099.0, 418.0);
		leftDifficultyArrow.y = difficultyText.y;
		rightDifficultyArrow.y = difficultyText.y;
		highScoreText.setPosition(934.0, 500.0);
		highScoreText.fieldWidth = 330;
		selectDifficulty(difficulty);

		// Add song list text
		songListLabel = new FlxText(16.0, 408.0, 330, "- Tracks -");
		songListLabel.setFormat("Jann Script Bold", 34, FlxColor.WHITE, CENTER);
		add(songListLabel);
		songListText = new FlxText(16.0, 460.0, 330);
		songListText.setFormat("Jann Script Bold", 24, FlxColor.WHITE, CENTER);
		songListText.alpha = 0.75;
		add(songListText);

		stagePreview = cast stage.getElementWithTag("stage_preview");
		player = cast stage.getElementWithTag("menu_player");
		opponent = cast stage.getElementWithTag("menu_opponent");
		girlfriend = cast stage.getElementWithTag("menu_girlfriend");

		colorSplitPlayer = cast stage.getElementsWithTag("color_split_player");
		colorSplitOpponent = cast stage.getElementsWithTag("color_split_opponent");

		menu.addItems(getMainMenuItems());

		// Update the player character sprite
		var character:CharacterData = Settings.getPlayerCharacter();
		player.loadFromID(character.menuSpriteID);
		player.scale.set(character.menuSpriteScale, character.menuSpriteScale);
		// Update the player character's colors
		for (sprite in colorSplitPlayer)
			sprite.color = character.themeColor;

		// Update the girlfriend character sprite
		character = Settings.getGirlfriendCharacter();
		girlfriend.loadFromID(character.menuSpriteID);
		girlfriend.scale.set(character.menuSpriteScale, character.menuSpriteScale);

		/* Default the opponent color split to the initial selected week
			(so it doesn't start by fading from white) */
		var color:FlxColor = PrePlayState.getOpponentThemeColor(album.weeks[menu.selectedItem].previewOpponentID);
		for (sprite in colorSplitOpponent)
		{
			FlxTween.cancelTweensOf(sprite);
			sprite.color = color;
		}
	}

	function getMenuID():String
	{
		return "week_select";
	}

	function getMainMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		var i:Int = 0;
		for (week in album.weeks)
		{
			items.push(new FlashingButtonMenuItem(week.itemName, {
				onSelected: function()
				{
					// Update the title
					currentTitle = week.name;

					// Update the high score
					currentHighScore = Scores.getWeekHighScore(albumID, i, difficulty);

					// Update the song list
					songListText.text = "";
					for (songID in week.songIDs)
						songListText.text += SongRegistry.getAsset(songID).name + "\n";

					// Update the stage
					stagePreview.loadFromID(StageDataRegistry.getAsset(week.previewStageID).previewSpriteID);

					// Update the opponent character sprite
					if (week.previewOpponentID != null && week.previewOpponentID != "") // If there is an opponent
					{
						var character:CharacterData = CharacterDataRegistry.getAsset(week.previewOpponentID);
						opponent.loadFromID(character.menuSpriteID);
						opponent.scale.set(character.menuSpriteScale, character.menuSpriteScale);
						opponent.revive();
					}
					else // If there isn't an opponent (only the case for the tutorial usually)
						opponent.kill();

					// Update the opponent character's colors
					var color:FlxColor = PrePlayState.getOpponentThemeColor(week.previewOpponentID);
					for (sprite in colorSplitOpponent)
					{
						FlxTween.cancelTweensOf(sprite);
						FlxTween.color(sprite, 0.25, sprite.color, color);
					}

					GlobalScriptRegistry.callAll("onWeekSelected", [week]);
				},
				onInteracted: function(value:Dynamic)
				{
					GlobalScriptRegistry.callAll("onWeekInteracted", [week]);
					prePlayTransition(new PlayState(null, difficulty, week));
					player.enableBopAnim = false;
					player.playAnimation("hey", true);
				}
			}));
			i++;
		}
		return items;
	}
}
