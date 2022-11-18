package stage;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

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
		if (parsed == null)
			return null;
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
			// First, find the class for the element using its type
			var elementClass:Class<Dynamic> = Type.resolveClass("stage.elements." + element.type);
			if (elementClass == null) // If it wasn't found, don't create it
				continue;
			// Create the instance
			sprite = cast Type.createInstance(elementClass, [element.name, element.data]);
			// Fill in the rest of the sprite data
			sprite.setPosition(element.x, element.y);

			sprite.camera = stageCamera;
			sprite.scrollFactor = new FlxPoint(element.scrollFactorX, element.scrollFactorY);

			sprite.scale = new FlxPoint(element.scaleX, element.scaleY);
			sprite.updateHitbox();
			sprite.angle = element.rotation;
			add(sprite);
		}
	}

	/** Returns a member of the given type. **/
	public function getElement<T>():T
	{
		for (member in members) {}
		return null;
	}
}
