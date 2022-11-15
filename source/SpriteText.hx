package;

import flixel.util.FlxColor;
import AssetSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

/** Prints a string using a series of sprites. **/
class SpriteText extends FlxSpriteGroup
{
	static final UPPERCASE_LETTERS:Array<String> = [
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	];

	/** ID for the default font. **/
	public static inline final DEFAULT_FONT_ID:String = "menus/_shared/sprite_text_font";

	public var text(default, null):String;

	/** Note: animation X-offsets are used for kerning and the Y-offsets shift the baseline. **/
	public var font(default, null):AssetSpriteData;

	/** The size of the font. Gets multiplied with the original sprite sizes. **/
	public var fontSize(default, null):Float;

	/** When true, an alternate animation for the font is used. **/
	public var bold(default, null):Bool;

	var charSprites:Array<AssetSprite> = new Array<AssetSprite>();

	public function new(x:Float, y:Float, text:String, fontSize:Float = 1.0, bold:Bool = false, font:AssetSpriteData = null)
	{
		super(x, y);
		this.font = font;
		if (font == null)
			font = AssetSpriteRegistry.getAsset(DEFAULT_FONT_ID);
		this.fontSize = fontSize;
		this.bold = bold;
		setText(text);

		var testSprite:FlxSprite = new FlxSprite(0.0, 0.0);
		testSprite.makeGraphic(5, 5, FlxColor.RED);
		add(testSprite);
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
				return "question";
			case "!":
				return "exclamation";
			case "'":
				return "apostrophe";
			case "’":
				return "apostrophe";
			case "\"":
				return "quote";
			case "“":
				return "start quote";
			case "”":
				return "end quote";
			case "&":
				return "ampersand";
			case "<":
				return "less than";
			case "/":
				return "forward slash";
			case "\\":
				return "back slash";
			default:
				return char;
		}
	}

	public inline function setText(text:String)
	{
		this.text = text;
		updateText();
	}

	/** Builds and updates the character sprites. **/
	function updateText()
	{
		// First, reset the current characters
		for (charSprite in charSprites)
			remove(charSprite);
		charSprites = new Array<AssetSprite>();

		var char:String;
		var x:Float = 0.0;
		var charSprite:AssetSprite;
		var newAnimation:AnimationData;
		for (i in 0...text.length)
		{
			char = text.charAt(i);
			// Create the animation data to play on this character
			newAnimation = Reflect.copy(getFontAnimation(char, bold));
			if (char == " ") // Rather than creating a character for a space, just... Add a space
			{
				x += newAnimation.offsetX * fontSize;
				continue;
			}
			newAnimation.name = "idle";
			newAnimation.atlasPrefix = getCharAtlasPrefix(char) +
				newAnimation.atlasPrefix; // The atlas prefix does not initially start out with the character identifier

			// Offset x is treated like kerning and offset y is treated like a baseline offset
			charSprite = new AssetSprite(x, newAnimation.offsetY, font);
			charSprite.useAnimDataOffsets = false; // We don't want the character to set its own offsets
			charSprite.loadAnimation(newAnimation);

			charSprite.scale = new FlxPoint(fontSize, fontSize);
			charSprite.updateHitbox();
			charSprite.offset = new FlxPoint(0.0, charSprite.height / 2.0); // Make the character align to the baseline
			x += charSprite.width + newAnimation.offsetX * fontSize;

			// Play the animation that was added earlier
			charSprite.animation.play("idle");
			charSprites.push(charSprite);
			add(charSprite);
		}
	}

	public inline function setBold(value:Bool)
	{
		bold = value;
		updateText();
	}
}
