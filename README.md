# ◄ ▼ Friday Night Rewrite ▲ ►
An engine for Friday Night Funkin' reprogrammed completely from the ground-up!

## (NOTE: This project has been unfinished for a long time and is pretty much abandoned! THE GAMEPLAY LITERALLY DOES NOT WORK! THE MOST IMPORTANT PART IS NOT DONE!)

### This site is for accessing the project's source code. If you want to download Friday Night Rewrite normally, do so here:

This is the repository for Friday Night Rewrite, a full code rewrite of the original game Friday Night Funkin'. The modding community for this game is huge, and yet despite numerous engines (mods meant to make mods easier) being released, I still felt like making mods was really messy. The foundations of the codebase were so shaky, it just made more sense to start from the ground-up. Hence why I made Friday Night Rewrite.

**Credits/shoutouts to the original FNF team!!!!**
- [ninjamuffin99](https://twitter.com/ninja_muffin99)
- [PhantomArcade3K](https://twitter.com/phantomarcade3k)
- [Evilsk8r](https://twitter.com/evilsk8r)
- [Kawaisprite](https://twitter.com/kawaisprite)

**Support the original game!!!!**
- Play the Newgrounds version: https://www.newgrounds.com/portal/view/770371
- Support the full game on Kickstarter: https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game

## Features
- Support for custom albums, weeks, songs, characters, and even STAGES and MENUS without need for scripting!
- Custom editors for everything you could need in a mod
- Event notes
- Dialogue system
- A playable character unlocking system! Mods can add playable characters, and if the player unlocks one they can use them in any song from any other mod
- Achievements!
- An "album" system, which are like groups of weeks. This means a mod can seperate itself from another mod's content
- A port of the original FNF with subtle improvements

**Technical features:**
- Runtime scripts using hscript!
- A new mod loading system, where mods can set dependencies and override other mods. Additionally, mods can set what version they are (and what dependency versions they expect) and even use a URL to detect if a mod is outdated
- Animations and other stuff for sprites can be defined in a JSON file alongside any PNG file and loaded in dynamically
- If a sound has variants, these can be defined in JSON files. These JSON files can also define their volumes
- Support for character sprite variants. For instance: Week 5 in FNF loads a christmas version of BF's sprite. With this system though, you could also have a custom character with a christmas version which gets automatically loaded in Week 5 songs
- Custom arrow types
- Custom stage elements
- Custom events
- Commented code
- And much more!

## How to Set Up
1. Go to https://haxe.org/download/ and download Haxe version 4.2.5 **(This is a different version number compared to vanilla FNF!!!!)**
2. Open Command Prompt with administrator privileges and enter the following (you need the most up-to-date version of these libraries):
   ```
   haxelib install lime
   haxelib install openfl
   haxelib install flixel
   haxelib install flixel-addons
   haxelib install flixel-ui
   haxelib install hscript
   ```

**Note: FNR is only designed to compile to desktop.** It cannot compile to HTML5 (browser mode basically), since it requires direct access to the file system to load assets and mods. Because of this, you also need to do this to compile to Windows:
1. Visit https://visualstudio.microsoft.com/vs/community/ and download Visual Studio Community
2. While installing, don't choose any option for a workload. Instead, go to the individual components tab and choose the following:
   - MSVC v142 - VS 2019 C++ x64/x86 build tools
   - Windows SDK (10.0.17763.0)

## How to Compile
1. Just type ```lime test windows``` in the console to test or use one of the batch files to compile!
