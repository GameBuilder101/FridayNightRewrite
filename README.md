# Friday Night Rewrite
A code rewrite/re-imagining of Friday Night Funkin'

### This site is for accessing the project's source code. If you want to download Friday Night Rewrite normally, do so here:

This is the repository for Friday Night Rewrite, a full code rewrite of the original game Friday Night Funkin'. The modding community for this game is huge, and yet despite numerous engines (mods meant to make mods easier) being released, I still felt like making mods was really messy. The foundations of the codebase were so shaky, it just made more sense to start from the ground-up. Hence why I made Friday Night Rewrite.

**Credits/shoutouts to the original FNF team!!!!**
- [ninjamuffin99](https://twitter.com/ninja_muffin99)
- [PhantomArcade3K](https://twitter.com/phantomarcade3k)
- [Evilsk8r](https://twitter.com/evilsk8r)
- [Kawaisprite](https://twitter.com/kawaisprite)

**Support the original game!!!!**
- Play the original Newgrounds version: https://www.newgrounds.com/portal/view/770371
- Support the full game on Kickstarter: https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game

## Features
- A playable character unlocking system! A mod could add a playable character, and if the player has them unlocked they can use them in any song from any other mod
- Achievements
- An "album" system, which are like groups of weeks. This means mods can seperate themselves from other mods' weeks
- Support for custom albums, weeks, stages, songs, characters, and stages without need for scripting!
- Custom editors for everything you could need in a mod
- A port of the original FNF

**Technical features:**
- A new mod loading system, where mods can set dependencies and override other mods. This means you can have mods... of mods!
- A sprite system where animations and other data can be defined in a JSON file for any graphic in the game
- A sound system where sound variations and volume can be defined in a JSON file for any sound in the game
- Characters can have multiple sprite variations defined in their JSON data. For instance: BF has his christmas outfit in Week 5. However, if you want a custom playable character to also have a christmas outfit, you can add that and it is automatically loaded for Week 5
- (Some) support for custom arrow types though JSON data
- **COMmeNTEd cODE?!?!?!?!?!?!?!??!?!?!?!! :scream::scream::scream:**

**Things to note:**
- FNR is only designed to compile to Windows. It cannot compile to HTML5 (browser mode basically), since it requires direct access to the file system to load assets and mods.
- FNR does not (yet) support LUA scripting. However, you can still add things like custom characters, stages, weeks, etc. without editing source code.

## How to Set Up and Compile
1. Go to https://haxe.org/download/ and download Haxe version 4.2.5 **(This is a different version number compared to vanilla FNF!!!!)**
2. Following https://haxeflixel.com/documentation/install-haxeflixel/, open Command Prompt with administrator privileges and enter the following:
   ```
   haxelib install hxcpp
   haxelib install lime
   haxelib install openfl
   haxelib install flixel
   ```
   It is also suggested (though not required) to run these commands:
   ```
   haxelib run lime setup flixel
   haxelib run lime setup
   ```
