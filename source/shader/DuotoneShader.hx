package shader;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

/** Interpolates between two colors based on the red channel of the input sprite. **/
class DuotoneShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
        uniform vec4 color1;
        uniform vec4 color2;
		
		void main()
		{
            vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = mix(color1, color2, base.x);
		}')
	public function new(args:Dynamic)
	{
		super();
		if (args.color1 != null)
			setColor1(FlxColor.fromRGB(args.color1[0], args.color1[1], args.color1[2], args.color1[3]));
		if (args.color2 != null)
			setColor2(FlxColor.fromRGB(args.color2[0], args.color2[1], args.color2[2], args.color2[3]));
	}

	public inline function setColor1(color:FlxColor)
	{
		color1.value = [color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat];
	}

	public inline function setColor2(color:FlxColor)
	{
		color2.value = [color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat];
	}
}
