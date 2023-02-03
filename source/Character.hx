package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import music.IConducted;
import music.Note;

using StringTools;

typedef CharacterData =
{
	name:String,
	variants:Array<CharacterVariant>,
	menuSpriteID:String,
	menuSpriteScale:Float,
	themeColor:FlxColor
}

typedef CharacterVariant =
{
	id:String,
	spriteID:String,
	deathSpriteID:String,
	spriteScale:Float,
	iconSpriteID:String
}

/** Use this to access/load character data. **/
class CharacterDataRegistry extends Registry<CharacterData>
{
	static var cache:CharacterDataRegistry = new CharacterDataRegistry();
	static var cachedIDs:Array<String>;

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
			cachedIDs = [];
		});
	}

	function loadData(directory:String, id:String):CharacterData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/character_data");
		if (parsed == null)
			return null;
		return {
			name: parsed.name,
			variants: parsed.variants,
			menuSpriteID: parsed.menuSpriteID,
			menuSpriteScale: parsed.menuSpriteScale,
			themeColor: FlxColor.fromRGB(parsed.themeColor[0], parsed.themeColor[1], parsed.themeColor[2])
		};
	}

	public static function getAsset(id:String):CharacterData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("characters");
		return cachedIDs;
	}
}

/** A character is a sprite loaded from character data which has things like singing animations. IE: BF, GF, Dad, etc. **/
class Character extends FlxSpriteGroup implements IConducted
{
	public static inline final PLAYER_TAG = "player";
	public static inline final OPPONENT_TAG = "opponent";
	public static inline final GIRLFRIEND_TAG = "girlfriend";

	public var data(default, null):CharacterData;
	public var currentVariant(default, null):CharacterVariant;

	var sprite:AssetSprite;

	var danceRight:Bool;

	var singingNotes:Array<Note> = [];

	/** Used for the game-over. **/
	var dead:Bool;

	public function new(x:Float, y:Float, ?data:CharacterData = null, ?id:String = null, variantID:String = null)
	{
		super(x, y);
		sprite = new AssetSprite(x, y);
		add(sprite);

		if (data != null)
			loadFromData(data, variantID);
		else if (id != null)
			loadFromID(id, variantID);
	}

	public function loadFromData(data:CharacterData, variantID:String = null)
	{
		this.data = data;
		setVariant(variantID);
	}

	public function loadFromID(id:String, variantID:String = null)
	{
		var data:CharacterData = CharacterDataRegistry.getAsset(id);
		if (data != null)
			loadFromData(data);
	}

	/** Sets the sprite variant to use.
		@param variantID If set to null, "normal" will be used as the default.
	**/
	public function setVariant(variantID:String = null)
	{
		if (variantID == null)
			variantID = "normal";
		for (variant in data.variants)
		{
			if (variant.id != variantID)
				continue;
			currentVariant = variant;
			break;
		}

		sprite.loadFromID(currentVariant.spriteID);
		sprite.scale.set(currentVariant.spriteScale, currentVariant.spriteScale);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Play sustain animation if still singing after main sing animation finishes
		if (getIsSinging())
			sprite.playAnimation("sing_" + Note.laneIndexToID(singingNotes[singingNotes.length - 1].lane) + "_sustain");
	}

	public function updateMusic(time:Float, bpm:Float, beat:Float) {}

	public function onWholeBeat(beat:Int)
	{
		if (dead) // Dead idle animation
		{
			if (beat % 2.0 == 0.0)
				sprite.playAnimation("idle");
			return;
		}

		if (sprite.animation.exists("dance")) // If there is a singular dance animation
		{
			sprite.playAnimation("dance");
			return;
		}

		if (danceRight) // If there is a back-and-forth dance animation
			sprite.playAnimation("dance_right");
		else
			sprite.playAnimation("dance_left");
		danceRight = !danceRight;
	}

	public function startSinging(note:Note)
	{
		if (dead)
			return;
		singingNotes.push(note);
		// Start the singing
		sprite.playAnimation("sing_" + Note.laneIndexToID(note.lane), true);
	}

	public function stopSinging(note:Note)
	{
		if (!singingNotes.contains(note))
			return;
		singingNotes.remove(note);
	}

	public inline function getIsSinging():Bool
	{
		return singingNotes.length > 0;
	}

	public function die()
	{
		if (dead)
			return;
		dead = true;
		singingNotes = []; // Stop singing
		sprite.loadFromID(currentVariant.deathSpriteID); // Switch to death sprite
		sprite.playAnimation("dying", true);
	}
}
