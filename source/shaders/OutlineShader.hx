package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

/** An outline shader. Only works well for animated sprites if the sprite sheet has big gaps! **/
class OutlineShader extends FlxShader
{
	// This code was originally written by AustinEast on GitHub! https://gist.github.com/AustinEast/d3892fdf6a6079366fffde071f0c2bae
	@:glFragmentSource('
		#pragma header
		uniform vec2 outlineSize;
		uniform vec4 outlineColor;
		
		void main()
		{
			vec4 base = texture2D(bitmap, openfl_TextureCoordv);
			if (base.a == 0.0)
			{
				float w = outlineSize.x / openfl_TextureSize.x;
				float h = outlineSize.y / openfl_TextureSize.y;
				if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.0
					|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.0
					|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.0
					|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.0)
					base = outlineColor;
			}
			gl_FragColor = base;
		}')
	public function new(args:Dynamic)
	{
		super();
		outlineSize.value = [args.size, args.size];
		var color:FlxColor = FlxColor.fromRGB(args.color[0], args.color[1], args.color[2], args.color[3]);
		outlineColor.value = [color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat];
	}
}
