package shader;

import flixel.system.FlxAssets.FlxShader;

class VCRShader extends FlxShader implements IUpdatableShader
{
	// This code was taken from the Andromeda engine on GitHub! https://github.com/nebulazorua/andromeda-engine-legacy/blob/master/source/Shaders.hx
	@:glFragmentSource('
		#pragma header
		uniform float time;

		uniform bool perspectiveOn;

		uniform bool distortionOn;
		uniform float glitchModifier;

		uniform bool vignetteOn;
		uniform bool vignetteMoving;

		uniform bool noiseOn;
		uniform sampler2D noiseTex;

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

		float random(vec2 uv)
		{
			return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(time * 0.03));
		}

		vec2 screenDistort(vec2 uv)
		{
			if(perspectiveOn)
			{
				uv = (uv - 0.5) * 2.0;
				uv *= 1.1;
				uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
				uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
				uv = (uv / 2.0) + 0.5;
				uv =  uv * 0.92 + 0.04;
				return uv;
			}
			return uv;
		}

		vec2 scanDistort(vec2 uv)
		{
			float scan1 = clamp(cos(uv.y * 2.0 + time), 0.0, 1.0);
			float scan2 = clamp(cos(uv.y * 2.0 + time + 4.0) * 10.0, 0.0, 1.0);
			float amount = scan1 * scan2 * uv.x;
			uv.x -= 0.05 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.9);
			return uv;
		}

		vec4 getVideo(vec2 uv)
		{
			vec2 look = uv;
			if (distortionOn)
			{
				float window = 1.0 / (1.0 + 20.0 * (look.y - mod(time / 4.0, 1.0)) * (look.y - mod(time / 4.0, 1.0)));
				look.x = look.x + (sin(look.y * 10.0 + time) / 50.0 * onOff(4.0, 4.0, 0.3) * (1.0 + cos(time * 80.0)) * window) * (glitchModifier * 2.0);
				float vShift = 0.4 * onOff(2.0, 3.0, 0.9) * (sin(time) * sin(time * 20.0) + (0.5 + 0.1 * sin(time * 200.0) * cos(time)));
				look.y = mod(look.y + vShift * glitchModifier, 1.0);
			}
			vec4 video = flixel_texture2D(bitmap,look);
			return video;
		}

		float noise(vec2 uv)
		{
			vec2 i = floor(uv);
			vec2 f = fract(uv);

			float a = random(i);
			float b = random(i + vec2(1.0, 0.0));
			float c = random(i + vec2(0.0, 1.0));
			float d = random(i + vec2(1.0));

			vec2 u = smoothstep(0.0, 1.0, f);

			return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
		}

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec2 curUV = screenDistort(uv);
			uv = scanDistort(curUV);
			vec4 video = getVideo(uv);
			float vigAmt = 1.0;
			float x = 0.0;

			video.r = getVideo(vec2(x + uv.x + 0.001, uv.y + 0.001)).x + 0.05;
			video.g = getVideo(vec2(x + uv.x + 0.000, uv.y - 0.002)).y + 0.05;
			video.b = getVideo(vec2(x + uv.x - 0.002, uv.y + 0.000)).z + 0.05;
			video.r += 0.08 * getVideo(0.75 * vec2(x + 0.025, -0.027) + vec2(uv.x + 0.001, uv.y + 0.001)).x;
			video.g += 0.05 * getVideo(0.75 * vec2(x + -0.022, -0.02) + vec2(uv.x + 0.000, uv.y - 0.002)).y;
			video.b += 0.08 * getVideo(0.75 * vec2(x + -0.02, -0.018) + vec2(uv.x - 0.002, uv.y + 0.000)).z;

			video = clamp(video * 0.6 + 0.4 * video * video, 0.0, 1.0);
			if(vignetteMoving)
				vigAmt = 3.0 + 0.3 * sin(time + 5.0 * cos(time * 5.0));
			float vignette = (1.0 - vigAmt * (uv.y - 0.5) * (uv.y - 0.5)) * (1.0 - vigAmt * (uv.x - 0.5) * (uv.x - 0.5));
			if(vignetteOn)
				video *= vignette;

			if(curUV.x < 0.0 || curUV.x > 1.0 || curUV.y < 0.0 || curUV.y > 1.0)
			{
				gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
			}
			else
			{
				if(noiseOn)
				{
					gl_FragColor = mix(video, vec4(noise(uv * 75.0)), 0.01);
				}
				else
				{
					gl_FragColor = video;
				}
			}
		}
	')
	public function new(args:Dynamic)
	{
		super();
		time.value = [0.0];

		if (args.perspectiveOn == null)
			args.perspectiveOn = true;
		perspectiveOn.value = [args.perspectiveOn];

		if (args.distortionOn == null)
			args.distortionOn = true;
		distortionOn.value = [args.distortionOn];
		glitchModifier.value = [args.glitchModifier];

		if (args.vignetteOn == null)
			args.vignetteOn = true;
		vignetteOn.value = [args.vignetteOn];
		if (args.vignetteMoving == null)
			args.vignetteMoving = true;
		vignetteMoving.value = [args.vignetteMoving];

		if (args.noiseOn == null)
			args.noiseOn = true;
		noiseOn.value = [args.noiseOn];
	}

	public function update(elapsed:Float)
	{
		time.value[0] += elapsed;
	}
}
