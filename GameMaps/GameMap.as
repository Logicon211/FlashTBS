package GameMaps
{
	public class GameMap
	{
		protected var width:int; //width of the map
		protected var height:int;//height of the map
		
		public var map:Array;//Map array
		
		protected var mapName:String; //map name
		protected var description:String; //Map description
		
		public var planetList:Array = new Array(); //list of planets on the map
		
		public function GameMap()
		{
			//Nothing in here
		}
		
		public function ConstructMap(numPlayers:int, players:Array):Array //This is the consruction of the map itself. Each map class is a separate map and Thus this will be an overwritten function in each subclass
		{
			//Must declare map as an Array of arrays
			
			return map; //must return map
		}
		
		public function getWidth():int
		{
			return width;
		}
		
		public function getHeight():int
		{
			return height
		}
		
		public function getName():String
		{
			return mapName;
		}
		
		public function getDescription():String
		{
			return description;
		}
	}
}