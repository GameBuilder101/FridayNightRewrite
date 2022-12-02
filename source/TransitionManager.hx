package;

import AssetSprite;
import assetManagement.ParsedJSONRegistry;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class TransitionManager
{
	/** Updates the default transitions in FlxTransitionableState. **/
	public static function updateDefaultTrans()
	{
		var transition:TransitionData = fromJSON("_shared/default_transition_data");
		if (transition == null)
			return;
		FlxTransitionableState.defaultTransIn = transition;
		FlxTransitionableState.defaultTransOut = transition;
	}

	/** Creates transition data from a JSON file. **/
	public static function fromJSON(id:String):TransitionData
	{
		var parsed:Dynamic = ParsedJSONRegistry.getAsset(id);
		if (parsed == null)
			return null;
		var sprite:AssetSpriteData = AssetSpriteRegistry.getAsset(parsed.tileSpriteID);
		return new TransitionData(parsed.type, FlxColor.fromRGB(parsed.color[0], parsed.color[1], parsed.color[2], parsed.color[3]), parsed.duration,
			new FlxPoint(parsed.directionX, parsed.directionY), {
				asset: sprite != null ? sprite.graphic : null,
				width: parsed.tileWidth,
				height: parsed.tileHeight
			});
	}
}
