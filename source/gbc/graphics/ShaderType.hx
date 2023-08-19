package gbc.graphics;

import flixel.system.FlxAssets.FlxShader;

/** This shader structure is set up to, in the future,
	support runtime shaders. However, for now, all 
	shaders must be builtin and referenced in a file using
	the class name. NOTE: the referenced class must have exactly
	one dynamic as the constructor argument!
**/
class ShaderType
{
	public var builtin:String;

	public function new(builtin:String)
	{
		this.builtin = builtin;
	}

	public function create(args:Dynamic):FlxShader
	{
		var cl:Class<Dynamic> = Type.resolveClass(builtin);
		if (cl == null)
			return null;
		return Type.createInstance(cl, [args]);
	}
}
