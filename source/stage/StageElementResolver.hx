package stage;

import stage.elements.*;

/** Handles the conversion of a stage element type to a string and vice-versa. **/
class StageElementResolver
{
	/** A list of all valid types of elements. **/
	public static final ALL:Array<String> = ["general_sprite", "menu", "menu_record", "logo"];

	/** Creates a new element from the provided type name and returns it. **/
	public static function resolve(type:String, data:Dynamic):StageElement
	{
		switch (type)
		{
			case "general_sprite":
				return new GeneralSpriteElement(data);
			case "menu":
				return new MenuElement(data);
			case "menu_record":
				return new MenuRecordElement(data);
			case "logo":
				return new LogoElement(data);
		}
		return null;
	}
}
