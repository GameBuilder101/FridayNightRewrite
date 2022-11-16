package;

import AssetSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/** Prints a string using a series of sprites. **/
class SpriteText extends FlxSpriteGroup
{
	static final UPPERCASE_LETTERS:Array<String> = [
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	];

	static final MIDDLE_ALIGN_CHARACTERS:Array<String> = ["+", "-", "~"];
	static final TOP_ALIGN_CHARACTERS:Array<String> = ["'", "’", "\"", "“", "”", "`", "*", "^"];

	/** ID for the default font. **/
	public static inline final DEFAULT_FONT_ID:String = "menus/_shared/sprite_text_font";

	public var text(default, null):String;

	/** Note: animation X-offsets are used for kerning and the Y-offsets shift the baseline. **/
	public var font(default, null):AssetSpriteData;

	/** The size of the font. Gets multiplied with the original sprite sizes. **/
	public var fontSize(default, null):Float;

	/** When true, an alternate animation for the font is used. **/
	public var bold(default, null):Bool;

	// Values for wave animation
	var waveMagnitude:Float;
	var waveFrequency:Float;
	var waveSpeed:Float;

	// Values for color animation
	var colorShift:Array<FlxColor>;
	var colorShiftSpeed:Float;
	var colorShiftPos:Float;

	/** 1 when going right and -1 when going left. **/
	var colorShiftDir:Int;

	public function new(x:Float, y:Float, text:String, fontSize:Float = 1.0, bold:Bool = false, font:AssetSpriteData = null)
	{
		super(x, y);
		if (font == null)
			font = AssetSpriteRegistry.getAsset(DEFAULT_FONT_ID);
		this.font = font;
		this.fontSize = fontSize;
		this.bold = bold;
		setText(text);
	}

	public inline function setFont(font:AssetSpriteData, fontSize:Float = 1.0)
	{
		this.font = font;
		this.fontSize = fontSize;
		// The text must be re-built when the font is changed
		updateText();
	}

	/** Returns the corresponding animation from the font data. **/
	function getFontAnimation(char:String, bold:Bool):AnimationData
	{
		var name:String;
		if (char == " ")
			name = "space";
		else if (UPPERCASE_LETTERS.contains(char))
			name = "uppercase";
		else
			name = "lowercase";
		if (bold)
			name += "_bold";

		for (animation in font.animations)
		{
			if (animation.name == name)
				return animation;
		}
		return null;
	}

	public inline function setBold(value:Bool)
	{
		bold = value;
		updateText();
	}

	public inline function setText(text:String)
	{
		this.text = text;
		updateText();
	}

	/** Builds and updates the character sprites. **/
	function updateText()
	{
		/* First, we need to make sure we have the right amount of sprites. Calculate the
			target number and add or subtract sprites until we have the right amount */
		var targetSpriteCount:Int = getSpriteCount(text);
		var sprite:FlxSprite;
		var assetSprite:AssetSprite;
		while (members.length > targetSpriteCount)
		{
			sprite = members[members.length - 1];
			remove(sprite, true);
			sprite.destroy();
		}
		while (members.length < targetSpriteCount)
		{
			assetSprite = new AssetSprite(0.0, 0.0);
			assetSprite.useAnimDataOffsets = false; // We don't want the character to set its own offsets
			add(assetSprite);
		}

		// Now, update the sprites to reflect the characters in the string
		var spriteIndex:Int = 0;
		var char:String;
		var x:Float = 0.0;
		var newAnimation:AnimationData;
		for (i in 0...text.length)
		{
			char = text.charAt(i);
			// Create the animation data to play on this character
			newAnimation = Reflect.copy(getFontAnimation(char, bold));
			if (char == " ")
			{
				/* Rather than creating a character for a space, just... Add a space. We must do this after getting
					the animation so that we can get the space size from the x-offset */
				x += newAnimation.offsetX * fontSize;
				continue;
			}
			newAnimation.name = "idle";
			newAnimation.atlasPrefix = getCharAtlasPrefix(char) + newAnimation.atlasPrefix;

			assetSprite = cast members[spriteIndex];
			// X-offset is treated like kerning
			assetSprite.setPosition(this.x + x, this.y + 0.0);
			// Load the font (if it isn't already)
			if (assetSprite.data != font)
				assetSprite.loadFromData(font);
			assetSprite.loadAnimation(newAnimation);
			assetSprite.animation.play("idle"); // Play the animation that was added

			// Scale and position the sprite
			assetSprite.scale = new FlxPoint(fontSize, fontSize);
			assetSprite.updateHitbox();
			assetSprite.origin = new FlxPoint(0.0, 0.0);
			// Set the character's height
			assetSprite.offset = new FlxPoint(0.0, (assetSprite.height - (newAnimation.offsetY * fontSize)) * getCharVerticalAlignment(char));
			x += assetSprite.width + newAnimation.offsetX * fontSize; // Shift over to update the next character sprite

			spriteIndex++;
		}

		updateHitbox();
	}

	/** Returns the number of sprites that will be needed to display the string. **/
	function getSpriteCount(string:String):Int
	{
		var count = 0;
		for (i in 0...string.length)
		{
			if (string.charAt(i) != " ")
				count++;
		}
		return count;
	}

	/** Converts a character to the name used on the font atlas. **/
	function getCharAtlasPrefix(char:String):String
	{
		switch (char)
		{
			case ".":
				return "period";
			case ",":
				return "comma";
			case "?":
				return "question_mark";
			case "!":
				return "exclamation_mark";
			case "'":
				return "apostrophe";
			case "’":
				return "apostrophe";
			case "\"":
				return "quote";
			case "“":
				return "start_quote";
			case "”":
				return "end_quote";
			case "&":
				return "ampersand";
			case "<":
				return "less_than";
			case "/":
				return "forward_slash";
			case "\\":
				return "back_slash";
			default:
				return char.toLowerCase();
		}
	}

	/** Gets the alignment for a character.
		@return 1 is bottom, 0.5 is middle, and 0 is top.
	**/
	function getCharVerticalAlignment(char:String):Float
	{
		if (MIDDLE_ALIGN_CHARACTERS.contains(char))
			return 0.5;
		else if (TOP_ALIGN_CHARACTERS.contains(char))
			return 0.0;
		return 1.0;
	}

	/** Makes the text play an up/down wave animation. **/
	public function waveAnimation(magnitude:Float, frequency:Float, speed:Float)
	{
		waveMagnitude = magnitude;
		waveFrequency = frequency;
		waveSpeed = speed;
	}

	/** Makes the text change colors over time. **/
	public function colorShiftAnimation(colors:Array<FlxColor>, speed:Float)
	{
		colorShift = colors;
		colorShiftSpeed = speed;
		colorShiftPos = 0.0;
		colorShiftDir = 1;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Animate waving characters
		var i:Int = 0;
		for (sprite in members)
		{
			if (waveMagnitude != 0.0)
				sprite.y = FlxMath.fastSin((elapsed + (i * waveFrequency)) * waveSpeed) * waveMagnitude;
			else
				sprite.y = 0.0;
			i++;
		}

		// Animate the color shift
		if (colorShift != null && colorShift.length <= 1)
			color = colorShift[0]; // If there is only one color, just use the one color
		else if (colorShift != null)
		{
			// Get the indexes of the color to lerp between
			var index1:Int = Std.int((colorShift.length - 1) * colorShiftPos);
			var index2:Int = index1 + colorShiftDir;

			color = FlxColor.interpolate(colorShift[index1], colorShift[index2],);
			colorShiftPos += elapsed *
		}
		else
			color = FlxColor.WHITE;
	}
}
