package;

import flixel.system.FlxAssets.FlxShader;
import shaders.*;

/** Handles the conversion of a shader type to a string and vice-versa. **/
class ShaderResolver
{
	/** A list of all valid types of shader. **/
	public static final ALL:Array<String> = ["wave", "outline"];

	/** Creates a new shader from the provided type name and returns it. **/
	public static function resolve(type:String, args:Dynamic):FlxShader
	{
		switch (type)
		{
			case "wave":
				return new WaveShader(args);
			case "outline":
				return new OutlineShader(args);
		}
		return null;
	}
}
