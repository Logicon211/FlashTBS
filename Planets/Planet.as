package Planets
{
	import flash.display.MovieClip;
	
	public class Planet extends MovieClip
	{
		protected var planetName:String; //Planet's name
		protected var description:String; //Planet's description
		
		protected var map:Array; //The Map contained within the planet
		protected var mapHeight:int // The map's height
		protected var mapWidth:int // The map's width
		protected var resourcePoints:int //number of resource points
		
		protected var numCitiesByPlayer:Array = new Array(); //The number of cities owned by the player (Indexed by player number)
		protected var numResearchByPlayer:Array = new Array(); //The number of research centers owned by the player (Indexed by player number)
		
		protected var resourcesByPlayer:Array = new Array(); //the amount of resources per player on a specific planet
		protected var numResourcePointsByPlayer:Array = new Array(); //the amount of resource points owned by a player on this planet
		
		public function Planet()
		{
			//On planet creation is when the map is constructed (As it can only be constructed once)
		}
		
		public function getMap():Array
		{
			return map;
		}
		
		public function getHeight():int
		{
			return mapHeight;
		}
		
		public function getWidth():int
		{
			return mapWidth;
		}
		
		public function getNumResourcePoints():int
		{
			return resourcePoints;
		}
		
		public function getName():String
		{
			return planetName;
		}
		
		public function getDescription():String
		{
			return description;
		}
		
		public function addCity(playerNum:int):void //adds a city to the owning player number
		{
			if(numCitiesByPlayer[playerNum] == null)
			{
				numCitiesByPlayer[playerNum] = 1;
			}
			else 
			{
				numCitiesByPlayer[playerNum] = numCitiesByPlayer[playerNum] + 1;
			}
		}
		
		public function removeCity(playerNum:int):void //removes a city from the owning player number
		{
			numCitiesByPlayer[playerNum] = numCitiesByPlayer[playerNum] - 1;
		}
		
		public function addResearch(playerNum:int):void //adds a Research Center to the owning player number
		{
			if(numResearchByPlayer[playerNum] == null)
			{
				numResearchByPlayer[playerNum] = 1;
			}
			else
			{
				numResearchByPlayer[playerNum] = numResearchByPlayer[playerNum] + 1;
			}
		}
		
		public function removeResearch(playerNum:int):void //removes a Reserach Center from the owning player number
		{
			numResearchByPlayer[playerNum] = numResearchByPlayer[playerNum] - 1;
		}
		
		public function getNumCities(playerNum:int):int //returns the number of cities owned by the player number
		{
			var ret:int = numCitiesByPlayer[playerNum]
			return ret;
		}
		
		public function getNumResearchCenters(playerNum:int):int //returns the number of research centers owned by the player number
		{
			return numResearchByPlayer[playerNum];
		}
		
		public function addResourcePoint(playerNum:int):void //adds a resourcePoint to the owning player number
		{
			if(numResourcePointsByPlayer[playerNum] == null)
			{
				numResourcePointsByPlayer[playerNum] = 1;
			}
			else 
			{
				numResourcePointsByPlayer[playerNum] = numResourcePointsByPlayer[playerNum] + 1;
			}
		}
		
		public function removeResourcePoint(playerNum:int):void //removes a Resource point from the owning player number
		{
			numResourcePointsByPlayer[playerNum] = numResourcePointsByPlayer[playerNum] - 1;
		}
		
		public function getNumResourcePointsByPlayer(playerNum:int):int //returns the number of resource points owned by the player on this planet
		{
			if(numResourcePointsByPlayer[playerNum] != null)
			{
				return numResourcePointsByPlayer[playerNum];
			}
			else
			{
				return 0;
			}
		}
		
		public function addResources(playerNum:int, amount:int):void //adds resources to the owning player number
		{
			if(resourcesByPlayer[playerNum] == null)
			{
				resourcesByPlayer[playerNum] = amount;
			}
			else 
			{
				resourcesByPlayer[playerNum] = resourcesByPlayer[playerNum] + amount;
			}
		}
		
		public function removeResources(playerNum:int, amount:int):void //removes resources from the owning player number
		{
				resourcesByPlayer[playerNum] = resourcesByPlayer[playerNum] - amount;
		}
		
		public function getPlayerResources(playerNum:int):int //returns the amount of resources held by a certain player on this planet
		{
			if(resourcesByPlayer[playerNum] == null)
			{
				resourcesByPlayer[playerNum] = 0;
			}
			
			return resourcesByPlayer[playerNum];
		}
	}
}