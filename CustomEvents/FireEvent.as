package CustomEvents
{
	import Map.MapTile;
	
	import flash.events.Event;
	
	//Event used to signal to a unit that it attacked and to perform any attack specials (like animations or other special abilities)
	public class FireEvent extends Event
	{
		public static const FIRE:String = "fire";
		
		public var mapTileToHit:MapTile;
		
		public function FireEvent(type:String, mapTile:MapTile, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.mapTileToHit = mapTile;
		}
		
		public override function clone():Event {
			return new FireEvent(type, mapTileToHit, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("FireEvent", "type", "mapTileToHit",
				"bubbles", "cancelable", "eventPhase");
		}
	}
}