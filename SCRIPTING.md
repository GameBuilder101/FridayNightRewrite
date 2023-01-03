# Scripting Reference
This document serves as a reference for writing Friday Night Rewrite scripts. This is not a tutorial, nor is it for beginners!

## General Overview
Scripting in Friday Night Rewrite works using **hscript** (https://github.com/HaxeFoundation/hscript), a simplified version of Haxe coding. Because of this, **it is recommended that you have at least a basic understanding of Haxe syntax**: https://haxe.org/manual. However, there are some big differences to note compared to proper Haxe:
- Currently, there is **no support for classes, typedefs, packages, or imports**
- The `switch` construct is supported but not pattern matching
- You can only declare one variable per `var` statement

Additionally, for more advanced scripts it is handy to have an understanding of the Friday Night Rewrite codebase.

It should be noted that import statements are not allowed (for security reasons and also cuz it'd be a pain to implement). Instead, **various classes are automatically imported into scripts** and you can just reference them directly.

## Table of Contents
- [Universal Imports](#universal-imports)
- [Universal Functions](#universal-functions)
- [Global-Script Callbacks](#global-script-callbacks)
- [Stage Element Callbacks](#stage-element-callbacks)
- [Event Type Callbacks](#event-type-callbacks)

## Universal Imports
The following are classes automatically imported into every type of script.

**Haxe stuff:**
- `Date`
- `DateTools`
- `Math`
- `Std`
- `StringTools`
- `haxe.Json`

**HaxeFlixel stuff:**
- `flixel.FlxBasic`
- `flixel.FlxCamera`
- `flixel.FlxG`
- `flixel.FlxObject`
- `flixel.FlxSprite`
- `flixel.FlxState`
- `flixel.FlxSubState`
- `flixel.animation.FlxAnimation`
- `flixel.effects.particles.FlxParticle`
- `flixel.effects.postprocess.PostProcess`
- `flixel.graphics.FlxGraphic`
- `flixel.graphics.frames.FlxAtlasFrames`
- `flixel.graphics.frames.FlxFrame`
- `flixel.graphics.frames.FlxFramesCollection`
- `flixel.graphics.frames.FlxImageFrame`
- `flixel.math.FlxAngle`
- `flixel.math.FlxMath`
- `flixel.math.FlxRandom`
- `flixel.math.FlxRect`
- `flixel.text.FlxText`
- `flixel.tweens.FlxEase`
- `flixel.tweens.FlxTween`
- `flixel.ui.FlxBar`
- `flixel.ui.FlxSpriteButton`
- `flixel.util.FlxGradient`
- `flixel.util.FlxTimer`
- `lime.app.Application`

**Friday Night Rewrite stuff:**
- `AssetSprite`
- `AssetSprite.AssetSpriteDataRegistry`
- `SpriteText`
- `SoundData`
- `SoundData.SoundDataRegistry`
- `music.MusicData`
- `music.MusicData.MusicDataRegistry`
- `music.Conductor`
- `music.Node`
- `music.Event`
- `shader.ShaderResolver`
- `assetManagement.FileManager`
- `assetManagement.LibraryManager`
- `Controls`
- `Settings`
- `ConductedState`
- `menu.Menu`
- `stage.Stage.StageDataRegistry`
- `Album.AlbumDataRegistry`
- `Week.WeekDataRegistry`
- `Song.SongDataRegistry`

## Universal Functions
The following are functions that you can call directly from any script (without having to reference a class).

**HaxeFlixel stuff:**
- `colorRGB(r:Int, g:Int, b:Int, a:Int = 255):FlxColor`
  - Returns a color
- `colorRGBFloat(r:Float, g:Float, b:Float, a:Float = 1.0):FlxColor`
  - Returns a color
- `colorString(str:String):FlxColor`
  - Returns a color (`str` should be something like a hex code)
- `colorInterpolate(color1:FlxColor, color2:FlxColor, factor:Float = 0.5):FlxColor`
  - Returns a color

**Friday Night Rewrite stuff:**
- `alert(message:String)`
  - Traces and makes a window alert. Useful for debugging
- `addSprite(x:Float, y:Float, id:String):AssetSprite`
  - Makes an asset-sprite and adds it to the current state
- `insertSprite(position:Int, x:Float, y:Float, id:String):AssetSprite`
  - Makes an asset-sprite and inserts it in the current state
- `playSound(id:String)`
- `playSoundOn(id:String, sound:FlxSound)`
  - Plays a sound with the given ID on a sound object
- `playMusic(id:String, looped:Bool, restart:Bool = true)`
- `transitionPlayMusic(id:String, looped:Bool, duration:Float, restart:Bool = true)`
- `loadStage(id:String)`
  - Loads and replaces the current stage (warning: doing this could cause bugs and be very laggy!)
- `getStageElements(targetTag:String):Array<FlxSprite>`
  - Gets all stage elements with the given tag
- `getStageElement(targetTag:String):FlxSprite`
  - Gets a singular stage element with the given tag
- `insertSpriteInStage(position:Int, x:Float, y:Float, id:String):AssetSprite`
  - Makes an asset-sprite and inserts it in the current stage
- `setVisible(targetTag:String, value:Bool)`
  - Sets a stage element visible
- `playAnim(targetTag:String, name:String)`
  - Plays an animation on a stage element

## Global-Script Callbacks
The following only applies to "global scripts". (**So not every type of script**... Kind of confusing, I know.)
When you add any of the following functions to your script, the engine will call them at the appropriate time.

- `onStart()`
  - Called on every script after every script has been parsed/initialized
- `onUpdate(elapsed:Float)`
  - Called every frame. `elapsed` is how many milliseconds passed since the last frame
- `onUpdateMusic(time:Float, bpm:Float, beat:Float)`
  - Called every frame while music is playing. Note that `beat` is not a whole number!
- `onWholeBeat(beat:Int)`
  - Called every whole beat
- `onStageCreated(stage:Stage)`
  - Called when a conducted state creates its stage
- `onPlayTitleScreenIntro()`
- `onSkipTitleScreenIntro()`
  - Called when intro is manually skipped. Note that `onEndTitleScreenIntro()` will also get called right after!
- `onEndTitleScreenIntro()`
- `onAlbumSelected(album:Album)`
  - Called when an album is selected or "hovered over" in the album select screen
- `onAlbumInteracted(album:Album)`
  - Called when an album is chosen in the album select screen
- `onWeekSelected(week:Week)`
  - Called when a week is selected or "hovered over" in the week select screen
- `onWeekInteracted(week:Week)`
  - Called when a week is chosen in the week select screen

## Stage Element Callbacks
When you add any of the following functions to your custom stage element script, the engine will call them at the appropriate time.

- `onNew(data:Dynamic)`
  - Called when the element is created. `data` contains any custom data that was provided by the stage editor
- `onUpdate(elapsed:Float)`
  - Called every frame. `elapsed` is how many milliseconds passed since the last frame
- `onUpdateMusic(time:Float, bpm:Float, beat:Float)`
  - Called every frame while music is playing. Note that `beat` is not a whole number!
- `onWholeBeat(beat:Int)`
  - Called every whole beat

**Note:** you can use `this` to access properties/functions of the stage element sprite itself

## Event Type Callbacks
When you add any of the following functions to your event type script, the engine will call them at the appropriate time.

- `onTrigger(state:ConductedState, time:Float, args:Dynamic)`
  - `state` is the state this event was triggered on (may not always be the PlayState!), `time` is the music time in milliseconds when it was triggered, and `args` contains any custom arguments set in the editor
