package;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class TransitionDataRegistry extends Registry<TransitionData>
{
	static var cache:TransitionDataRegistry = new TransitionDataRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
			updateDefaultTrans();
		});
	}

	function loadData(directory:String, id:String):TransitionData
	{
		var path:String = Registry.getFullPath(directory, id);
		var parsed:Dynamic = FileManager.getParsedJson(path);
		if (parsed == null)
			return null;

		return new TransitionData(parsed.type, FlxColor.fromRGB(parsed.color[0], parsed.color[1], parsed.color[2], parsed.color[3]), parsed.duration,
			new FlxPoint(parsed.directionX, parsed.directionY), {
				asset: FileManager.getGraphic(path),
				width: parsed.tileWidth,
				height: parsed.tileHeight
			});
	}

	public static function getAsset(id:String):TransitionData
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}

	/** Updates the default transitions in FlxTransitionableState. **/
	public static function updateDefaultTrans()
	{
		var data:TransitionData = getAsset("transitions/default");
		if (data == null)
			return;
		FlxTransitionableState.defaultTransIn = data;
		FlxTransitionableState.defaultTransOut = data;
	}
}
