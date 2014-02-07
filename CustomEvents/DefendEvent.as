package CustomEvents
{
	import flash.events.Event;
	
	//Event used to signal to a unit it was just hit by another unit
	public class DefendEvent extends Event
	{
		public static const DEFEND:String = "defend";
		
		public function DefendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}