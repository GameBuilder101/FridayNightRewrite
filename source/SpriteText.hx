package;

import AssetSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/** Sprite-Text prints a string using a series of sprites. **/
class SpriteText extends FlxSpriteGroup
{
	static final UPPERCASE_LETTERS:Array<String> = [
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	];

	public var text(default, null):String;

	/** Note: animation X-offsets are used for kerning and the Y-offsets shift the baseline. **/
	public var font(default, null):AssetSpriteData;

	/** The size of the font. Gets multiplied with the original sprite sizes. **/
	public var fontSize(default, null):Float;

	/** When true, an alternate animation for the font is used. **/
	public var bold(default, null):Bool;

	var charSprites:Array<AssetSprite> = new Array<AssetSprite>();

	public function new(x:Float, y:Float, text:String, font:AssetSpriteData, fontSize:Float = 1.0)
	{
		super(x, y);
		this.font = font;
		this.fontSize = fontSize;
		setText(text);
	}

	public function setFont(font:AssetSpriteData, fontSize:Float = 1.0)
	{
		this.font = font;
		this.fontSize = fontSize;
		// The text must be re-built when the font is changed
		updateText();
	}

	/** Returns the corresponding animation from the font data. **/
	function getAnimation(uppercase:Bool, bold:Bool):AnimationData
	{
		var name:String;
		if (uppercase)
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

	public function setText(text:String)
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

		var animation:AnimationData;
		var charSprite:AssetSprite;
		var kern:Float;
		for (i in 0...text.length)
		{
			animation = getAnimation(UPPERCASE_LETTERS.contains(text.charAt(i)), bold);
			charSprite = generateCharSprite(text.charAt(i), animation);
			charSprite.width *= fontSize;
			charSprite.height *= fontSize;

			kern = font.animations.charSprite.add(charSprite);
		}
	}

	function generateCharSprite(char:String, animation:AnimationData):AssetSprite
	{
		var charSprite:AssetSprite = new AssetSprite(0.0, 0.0);
	}

	public function setBold(value:Bool)
	{
		bold = value;
		updateText();
	}
}
