package stage;

import stage.elements.*;
import stage.elements.ScriptedElement;

/** Handles the conversion of a stage element type to a string and vice-versa. **/
class StageElementResolver
{
	static final BUILTIN:Array<String> = ["general_sprite", "box_sprite", "text", "menu", "character"];

	/** Returns a list of all element type names. **/
	public static function getAll():Array<String>
	{
		var all:Array<String> = BUILTIN.copy();
		for (id in ScriptedElementTypeRegistry.getAllIDs()) // Also include custom scripted types
			all.push(id);
		return all;
	}

	/** Creates a new element from the provided type name and returns it. **/
	public static function resolve(type:String, data:Dynamic):IStageElement
	{
		switch (type)
		{
			case "general_sprite":
				return new GeneralSpriteElement(data);
			case "box_sprite":
				return new BoxSpriteElement(data);
			case "text":
				return new TextElement(data);
			case "menu":
				return new MenuElement(data);
			case "character":
				return new CharacterElement(data);
			default: // If it was not a built-in type, try to see if it's a custom scripted type
				var elementType:Script = ScriptedElementTypeRegistry.getAsset(type);
				if (elementType == null) // If it isn't, then there is no element of this type
					return null;
				return new ScriptedElement(elementType, data);
		}
		return null;
	}
}
