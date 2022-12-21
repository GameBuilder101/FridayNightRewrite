package shader;

import flixel.system.FlxAssets.FlxShader;

class VHSShader extends FlxShader implements IUpdatableShader
{
	// This code was originally ported by jobf on GitHub! https://github.com/jobf/haxeflixel-vcr-effect-shader/blob/master/source/VhsShader.hx
	@:glFragmentSource('
        #pragma header
		uniform float time;

		uniform sampler2D noiseTexture;
		uniform float noisePercent;
		
		float rand(vec2 co)
		{
			float a = 12.9898;
			float b = 78.233;
			float c = 43758.5453;
			float dt = dot(co.xy, vec2(a, b));
			float sn = mod(dt, 3.14);
			return fract(sin(sn) * c);
		}

		float noise(vec2 p)
		{
			return rand(p) * noisePercent;
		}

		float onOff(float a, float b, float c)
		{
			return step(c, sin(time + a * cos(time * b)));
		}

		float ramp(float y, float start, float end)
		{
			float inside = step(start, y) - step(end, y);
			float fact = (y - start) / (end - start) * inside;
			return (1.0 - fact) * inside;
		}

		float stripes(vec2 uv)
		{
			float n = noise(uv * vec2(0.5, 1.0) + vec2(1.0, 3.0));
			return ramp(mod(uv.y * 4.0 + time / 2.0 + sin(time + sin(time * 0.63)), 1.0), 0.5, 0.6) * n;
		}

		vec3 getVideo(vec2 uv)
		{
			vec2 look = uv;
			float window = 1.0 / (1.0 + 20.0 * (look.y - mod(time / 4.0, 1.0)) * (look.y - mod(time / 4.0, 1.0)));
			look.x = look.x + sin(look.y * 10.0 + time) / 50.0 * onOff(4.0, 4.0, 0.3) * (1.0 + cos(time * 80.0)) * window;
			float vShift = 0.4 * onOff(2.0, 3.0, 0.9) * (sin(time) * sin(time * 20.0) + (0.5 + 0.1 * sin(time * 200.0) * cos(time)));
			look.y = mod(look.y + vShift, 1.0);
			vec3 video = vec3(flixel_texture2D(bitmap, look));
			return video;
		}

		vec2 screenDistort(vec2 uv)
		{
			uv -= vec2(0.5, 0.5);
			uv = uv * 1.2 * (1.0 / 1.2 + 2.0 * uv.x * uv.x * uv.y * uv.y);
			uv += vec2(0.5, 0.5);
			return uv;
		}

		void main()
        {
			vec2 uv = openfl_TextureCoordv.xy;
			uv = screenDistort(uv);
			vec3 video = getVideo(uv);
			float vigAmt = 3.0 + 0.3 * sin(time + 5.0 * cos(time * 5.0));
			float vignette = (1.0 - vigAmt * (uv.y - 0.5) * (uv.y - 0.5)) * (1.0 - vigAmt * (uv.x - 0.5) * (uv.x - 0.5));
			
			video += stripes(uv);
			video += noise(uv * 2.0) / 2.0;
			video *= vignette;
			video *= (12.0 + mod(uv.y * 30.0 + time, 1.0)) / 13.0;
			
			gl_FragColor = vec4(video, 1.0);
		}')
	public function new(args:Dynamic)
	{
		super();
		time.value = [0.0];
		noisePercent.value = [args.noisePercent];
	}

	public function update(elapsed:Float)
	{
		time.value[0] += elapsed;
	}
}
