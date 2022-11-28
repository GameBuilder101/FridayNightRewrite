package;

import assetManagement.LibraryManager;
import flixel.FlxGame;
import haxe.Http;
import haxe.Json;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var currentVersion(default, null):String;

	/** The latest version of the engine. Obtained from GitHub. **/
	public static var latestVersion(default, null):String;

	/** Whether the core library version is up-to-date with the latest version. **/
	public static var outdated(default, null):Bool;

	public function new()
	{
		super();
		LibraryManager.reloadLibraries(); // Load libraries before starting

		// Do this after loading libraries so core library version can be obtained
		currentVersion = LibraryManager.getCore().version;
		// Check for update
		getGitHubVersion(function(version:String)
		{
			latestVersion = version;
			outdated = currentVersion != latestVersion;
		});

		LibraryManager.preload();

		addChild(new FlxGame(0, 0, TitleScreenState, -1.0, 60, 60, true, false));
	}

	// Edited version check code was taken from Psych Engine! https://github.com/ShadowMario/FNF-PsychEngine
	static function getGitHubVersion(onData:String->Void)
	{
		trace("Checking for GitHub version...");

		var http:Http = new Http("https://gist.githubusercontent.com/GameBuilder101/74d21f1ca9199eb550531df2cab42111/raw/410d043422ff81ffcdff189e21f330d023c31217/fnr_library_placeholder.json"); // https://raw.githubusercontent.com/GameBuilder101/FridayNightRewrite/main/assets/library.json
		http.onData = function(data:String)
		{
			var parsed:Dynamic = Json.parse(data);
			if (parsed == null || parsed.version == null)
			{
				trace("Error! Could not find latest GitHub version: JSON data was malformed");
				return;
			}
			trace("Found GitHub version: '" + parsed.version + "'");
			onData(parsed.version);
		}
		http.onError = function(msg)
		{
			trace("Error! Could not find latest GitHub version: " + msg);
		}

		http.request();
	}
}
