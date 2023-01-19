package shader;

import AssetSprite;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxShader;
import openfl.display3D.Context3DWrapMode;

/** A shader that scrolls a texture over the sprite. **/
class GlintShader extends FlxShader implements IUpdatableShader
{
	@:glFragmentSource('
		#pragma header
        uniform float time;

        uniform vec2 glintSpeed;
		uniform sampler2D glintTex;
		
		void main()
		{
			vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
			vec4 glint = texture2D(glintTex, openfl_TextureCoordv + glintSpeed * time);
			gl_FragColor = base * glint;
		}')
	public function new(args:Dynamic)
	{
		super();
		time.value = [0.0];

		glintSpeed.value = [args.glintSpeedX, args.glintSpeedY];
		var graphic:FlxGraphic = AssetSpriteDataRegistry.getAsset(args.glintTexID).graphic;
		glintTex.width = graphic.width;
		glintTex.height = graphic.height;
		glintTex.input = graphic.bitmap;
		glintTex.wrap = Context3DWrapMode.REPEAT;
	}

	public function update(elapsed:Float)
	{
		time.value[0] += elapsed;
	}
}
