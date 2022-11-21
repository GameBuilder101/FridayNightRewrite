package stage;

// Important: if the element packages are not imported, they cannot be obtained through reflection!
import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

typedef StageData =
{
	name:String,
	elements:Array<StageElementData>
}

typedef StageElementData =
{
	// The name is mainly used to identify the sprite for a stage editor
	name:String,
	type:String,
	x:Float,
	y:Float,
	scrollFactorX:Float,
	scrollFactorY:Float,
	scaleX:Float,
	scaleY:Float,
	rotation:Float,
	data:Dynamic
}

/** Use this to access/load stages. **/
class StageRegistry extends Registry<StageData>
{
	static var cache:StageRegistry = new StageRegistry();
	static var cachedIDs:Array<String>;

	function loadData(directory:String, id:String):StageData
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id) + "/stage_data");
		if (parsed == null || parsed.elements == null || parsed.elements.length <= 0)
			return null;

		// Fill in default element values if the data is missing
		for (element in cast(parsed.elements, Array<Dynamic>))
		{
			if (element.x == null)
				element.x = 0.0;
			if (element.y == null)
				element.y = 0.0;
			if (element.scrollFactorX == null)
				element.scrollFactorX = 0.0;
			if (element.scrollFactorY == null)
				element.scrollFactorY = 0.0;
			if (element.scaleX == null)
				element.scaleX = 1.0;
			if (element.scaleY == null)
				element.scaleY = 1.0;
			if (element.rotation == null)
				element.rotation = 0.0;
			if (element.data == null)
				element.data = {};
		}

		return parsed;
	}

	public static function getAsset(id:String):StageData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Returns all IDs in a library-relative directory. This does not necessarily
		return ALL of them in the files, only ones in a specific folder. **/
	public static function getAllIDs():Array<String>
	{
		if (cachedIDs != null)
			return cachedIDs;
		cachedIDs = LibraryManager.getAllIDs("stages");
		return cachedIDs;
	}
}

/** Stages are collections of stage elements put together from a JSON file. They are used for backgrounds in things like songs and menus. **/
class Stage extends FlxSpriteGroup
{
	public var data(default, null):StageData;

	public var stageCamera(default, null):FlxCamera;

	/**
		@param data Data to be loaded on creation.
		@param id When supplied, the stage data will be retrieved via StageRegistry.getAsset.
	**/
	public function new(?data:StageData = null, ?id:String = null)
	{
		super(0.0, 0.0);

		stageCamera = new FlxCamera();
		stageCamera.bgColor.alpha = 0;
		FlxG.cameras.add(stageCamera);

		if (data != null)
			loadFromData(data);
		else if (id != null)
		{
			var foundData:StageData = StageRegistry.getAsset(id);
			if (foundData != null)
				loadFromData(foundData);
		}
	}

	/** Loads the stage information and creates elements from the provided data. **/
	public function loadFromData(data:StageData)
	{
		this.data = data;
		var sprite:FlxSprite;
		for (element in data.elements)
		{
			sprite = cast StageElementResolver.resolve(element.type, element.name, element.data);
			if (sprite == null) // If the type was invalid, just skip it
				continue;
			// Fill in the rest of the sprite data
			sprite.setPosition(element.x, element.y);

			sprite.camera = stageCamera;
			sprite.scrollFactor.set(element.scrollFactorX, element.scrollFactorY);

			sprite.scale.set(element.scaleX, element.scaleY);
			sprite.updateHitbox();
			sprite.angle = element.rotation;
			add(sprite);
			cast(sprite, StageElement).onAddedToStage(this);
		}
	}
}
