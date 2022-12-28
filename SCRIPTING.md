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

## Universal Imports {#universal-imports}
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
