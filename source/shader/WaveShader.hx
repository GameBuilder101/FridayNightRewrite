package shader;

import flixel.system.FlxAssets.FlxShader;

class WaveShader extends FlxShader implements IUpdatableShader
{
	// This code was originally written by Gama11 on GitHub! https://github.com/HaxeFlixel/flixel-demos/blob/dev/Effects/BlendModeShaders/source/openfl8/effects/WiggleEffect.hx
	@:glFragmentSource('
        #pragma header
        uniform float time;

        uniform int waveType;
        const int WAVE_TYPE_HORIZONTAL = 0;
		const int WAVE_TYPE_VERTICAL = 1;
		const int WAVE_TYPE_HEAT_WAVE_HORIZONTAL = 2;
		const int WAVE_TYPE_HEAT_WAVE_VERTICAL = 3;
        const int WAVE_TYPE_FLAG = 4;

        uniform float waveAmplitude;
        uniform float waveFrequency;
        uniform float waveSpeed;

        vec2 waveUV(vec2 pt)
		{
			float x = 0.0;
			float y = 0.0;
			
			if (waveType == WAVE_TYPE_HORIZONTAL) 
			{
				float offsetX = sin(pt.y * waveFrequency + time * waveSpeed) * waveAmplitude;
				pt.x += offsetX;
			}
			else if (waveType == WAVE_TYPE_VERTICAL) 
			{
				float offsetY = sin(pt.x * waveFrequency + time * waveSpeed) * waveAmplitude;
				pt.y += offsetY;
			}
			else if (waveType == WAVE_TYPE_HEAT_WAVE_HORIZONTAL)
			{
				x = sin(pt.x * waveFrequency + time * waveSpeed) * waveAmplitude;
			}
			else if (waveType == WAVE_TYPE_HEAT_WAVE_VERTICAL)
			{
				y = sin(pt.y * waveFrequency + time * waveSpeed) * waveAmplitude;
			}
			else if (waveType == WAVE_TYPE_FLAG)
			{
				y = sin(pt.y * waveFrequency + 10.0 * pt.x + time * waveSpeed) * waveAmplitude;
				x = sin(pt.x * waveFrequency + 5.0 * pt.y + time * waveSpeed) * waveAmplitude;
			}
			
			return vec2(pt.x + x, pt.y + y);
		}
		
		void main()
		{
			vec2 uv = waveUV(openfl_TextureCoordv);
			gl_FragColor = flixel_texture2D(bitmap, uv);
		}')
	public function new(args:Dynamic)
	{
		super();
		time.value = [0.0];

		waveType.value = [WaveShaderType.createByName(args.type).getIndex()];
		waveAmplitude.value = [args.amplitude];
		waveFrequency.value = [args.frequency];
		waveSpeed.value = [args.speed];
	}

	public function update(elapsed:Float)
	{
		time.value[0] += elapsed;
	}
}

enum WaveShaderType
{
	HORIZONTAL;
	VERTICAL;
	HEAT_WAVE_HORIZONTAL;
	HEAT_WAVE_VERTICAL;
	FLAG;
}
