package;

import Album;
import Character;
import GlobalScript;
import Week;
import flixel.FlxG;
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

class WeekSelectState extends MenuState implements IAlbumSelected
{
	/** The album that was selected in the album select state. **/
	public var album:AlbumData;

	/** An array of all detected/loaded weeks. **/
	public var weeks(default, null):Array<WeekData> = [];

	/** The currently-selected difficulty index. **/
	var difficulty:Int;

	var stagePreview:AssetSprite;
	var player:AssetSprite;
	var opponent:AssetSprite;
	var girlfriend:AssetSprite;

	var colorSplitPlayer:Array<AssetSprite> = [];
	var colorSplitOpponent:Array<AssetSprite> = [];

	var songListText:FlxText;

	var leftDifficultyArrow:AssetSprite;
	var difficultyText:SpriteText;
	var rightDifficultyArrow:AssetSprite;
	var highScoreText:FlxText;

	override function create()
	{
		super.create();

		stagePreview = cast stage.getElementWithTag("stage_preview");
		player = cast stage.getElementWithTag("menu_player");
		opponent = cast stage.getElementWithTag("menu_opponent");
		girlfriend = cast stage.getElementWithTag("menu_girlfriend");

		colorSplitPlayer = cast stage.getElementsWithTag("color_split_player");
		colorSplitOpponent = cast stage.getElementsWithTag("color_split_opponent");

		// Add song list text
		songListText = new FlxText(16.0, 408.0, 400);
		songListText.setFormat("Jann Script Bold", 17);
		add(songListText);

		// Add high score text
		highScoreText = new FlxText(864.0, 468.0, 400);
		highScoreText.setFormat("Jann Script Bold", 17);
		add(highScoreText);

		// Load weeks from the list in the album
		for (id in album.weekIDs)
			weeks.push(WeekDataRegistry.getAsset(id));

		menu.addItems(getMainMenuItems());

		// Just in case, play the menu music again
		Conductor.play(MusicDataRegistry.getAsset(album.menuMusicID), true, false);
		background.loadFromID(album.backgroundID);
		background.color = album.backgroundColor;

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
		var color:FlxColor = getOpponentThemeColor(weeks[menu.selectedItem]);
		for (sprite in colorSplitOpponent)
		{
			FlxTween.cancelTweensOf(sprite);
			sprite.color = color;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Go back to the main menu if the back button is pressed
		if (menu.interactable && Controls.cancel.check())
		{
			menu.playCancelSound();
			FlxG.switchState(new TitleScreenState());
		}
	}

	function getMenuID():String
	{
		return "week_select";
	}

	function getMainMenuItems():Array<MenuItem>
	{
		var items:Array<MenuItem> = [];
		for (week in weeks)
		{
			items.push(new FlashingButtonMenuItem(week.itemName, {
				onSelected: function()
				{
					// Update the week name
					currentTitle = week.name;
					// Update the song list
					songListText.text = "- Tracks -";
					for (songID in week.songIDs)
						songListText.text += "\n" + SongDataRegistry.getAsset(songID).name;
					// Update the high score text
					highScoreText.text = "High Score: " + 69420;

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
					var color:FlxColor = getOpponentThemeColor(week);
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
					specialTransition(new PlayState(null, difficulty, week));
					Conductor.fadeOut(0.8); // Fade out the music after being selected
				}
			}));
		}
		return items;
	}

	/** Returns the color to use for the opponent. **/
	function getOpponentThemeColor(week:WeekData):FlxColor
	{
		if (week.previewOpponentID == null)
			return Settings.getPlayerCharacter().themeColor;
		return CharacterDataRegistry.getAsset(week.previewOpponentID).themeColor;
	}
}
