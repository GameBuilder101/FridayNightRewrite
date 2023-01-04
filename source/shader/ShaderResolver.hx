package shader;

import flixel.system.FlxAssets.FlxShader;

/** Handles the conversion of a shader type to a string and vice-versa. **/
class ShaderResolver
{
	static final BUILTIN:Array<String> = ["wave", "outline", "vcr"];

	/** Returns a list of all shader type names. **/
	public static function getAll():Array<String>
	{
		return BUILTIN;
	}

	/** Creates a new shader from the provided type name and returns it. **/
	public static function resolve(type:String, args:Dynamic):FlxShader
	{
		if (args == null)
			args = {};
		switch (type)
		{
			case "wave":
				return new WaveShader(args);
			case "outline":
				return new OutlineShader(args);
			case "vcr":
				return new VCRShader(args);
		}
		return null;
	}
}
