package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

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
class Character extends FlxSpriteGroup
{
	public var data(default, null):CharacterData;

	public var currentVariant(default, null):CharacterVariant;

	var sprite:AssetSprite;

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
	public function setVariant(variantID:String)
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
	}
}
