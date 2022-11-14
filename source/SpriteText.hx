package;

import flixel.group.FlxSpriteGroup;

class SpriteText extends FlxSpriteGroup
{
    public var text(default, null):String;

    var characters:Array<FlxSprite> = new Array<FlxSprite>;

    function setText(text:String)
    {
        this.text = text;
        for (character in characters)
        {
        }
    }
}