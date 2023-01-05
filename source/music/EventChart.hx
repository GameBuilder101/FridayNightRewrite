package music;

import assetManagement.FileManager;
import assetManagement.LibraryManager;
import assetManagement.Registry;
import music.Event;

class EventChart extends Chart<Event> {}

/** Use this to access/load event charts. **/
class EventChartRegistry extends Registry<EventChart>
{
	static var cache:EventChartRegistry = new EventChartRegistry();

	public function new()
	{
		super();
		LibraryManager.onFullReload.push(function()
		{
			cache.clear();
		});
	}

	function loadData(directory:String, id:String):EventChart
	{
		var parsed:Dynamic = FileManager.getParsedJson(Registry.getFullPath(directory, id));
		if (parsed == null)
			return null;

		// Create the events from the chart data provided in the file
		var events:Array<Event> = [];
		for (node in cast(parsed, Array<Dynamic>))
			events.push(new Event(EventTypeRegistry.getAsset(node.type), node.time, node.args));

		return new EventChart(events);
	}

	public static function getAsset(id:String):EventChart
	{
		return LibraryManager.getLibraryAsset(id, cache);
	}
}
