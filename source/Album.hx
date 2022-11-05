package;

import assetManagement.Registry;

typedef AlbumData =
{
	name:String,
	credits:Array<Credit>
}

class AlbumRegistry extends Registry<AlbumData>
{
	public static inline final LIBRARY_DIRECTORY:String = "albums";

	function loadData(directory:String, id:String, fullPath:String):AlbumData
	{
		var parsed:Dynamic = Paths.getParsedJson(fullPath + "/album");
		if (parsed == null)
			return null;

		// Load the credits as an array of Credit
		var credits:Array<Credit> = new Array<Credit>();
		for (credit in cast(parsed.credits, Array<Dynamic>))
			credits.push(credit);

		return {name: parsed.name, credits: credits};
	}
}
