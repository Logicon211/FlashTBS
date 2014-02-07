package Player
{
	import Buildings.Building;
	
	import Research.ResearchItem;
	
	import Units.Unit;

	public class BasePlayer
	{
	
		//Player stats, like number and other important game info
		public var playerNumber:int;
		public var race:int;
		public var credits:int;
		public var resources:int; //Possibly temporary, not sure how this game is going to use resources yet
		public var numCities:int; //keeps track of the number of cities the player owns to calculate income
		public var numResearchCenters:int; //keeps track of the number of research centers to calculate research speed
		
		//linked list of owned units and buildings
		public var unitList:Array = new Array();
		public var buildingList:Array = new Array();
		
		//research item stuff
		public var researchList:Array; //Will contain the research list for that race
		public var activeResearch:ResearchItem = null; //currently researching this
		
		//Constants to help spread out race
		public static const HUMAN:int = 1;
		public static const TECH:int = 2;
		public static const INFECTED:int = 3;
		
		
		public function BasePlayer(playerNum:int, startingCredits:int, startingResources:int)
		{
			playerNumber = playerNum;
			credits = startingCredits;
			resources = startingResources;
		}
		
		public function renewTurn():void
		{
			for(var i:int = 0; i < unitList.length; i++) //goes through the unit list and renews each of the units' turn
			{
				unitList[i].renewTurn();
			}
			for(i = 0; i < buildingList.length; i++) //goes through the building list and renews each of the building's turn (to fire weapons)
			{
				buildingList[i].renewTurn();
			}
		}
		
		public function removeUnit(removedUnit:Unit):void
		{
			for(var i:int = 0; i < unitList.length; i++)
			{
				if(unitList[i] == removedUnit)
				{
					unitList.splice(i, 1); //if I read splice correctly this should remove the 1 unit at position i, and move everything after that point down one (so there's no open space)
				}
			}
		}
		
		public function removeBuilding(removedBuilding:Building):void
		{
			for(var i:int = 0; i < buildingList.length; i++)
			{
				if(buildingList[i] == removedBuilding)
				{
					buildingList.splice(i, 1); //if I read splice correctly this should remove the 1 unit at position i, and move everything after that point down one (so there's no open space)
				}
			}
		}
		
		//will give income and perform research
		public function giveIncome(planetList:Array):void
		{
			credits = credits + (numCities * 1000); //1000 credits per city owned
			
			//give resources on each planet
			for(var i:int=0; i<planetList.length; i++)
			{
				var numResourcePoints:int = planetList[i].getNumResourcePointsByPlayer(this.playerNumber); //gets the number of resource points owned by this player on planet i
				planetList[i].addResources(this.playerNumber, numResourcePoints * 10); //gives 10 resources per point, may change
			}
			
			//if active research isn't null
			if(activeResearch != null)
			{
				activeResearch.workTime( numResearchCenters * 5 /* TEST AMOUNT */);
			}
		}
		
		//stuff to do with Race and Research below*********************************************************************************************
		
		//Function that checks all research to see if the one passed in has been completed
		public function isResearchObjectComplete(research:ResearchItem):Boolean
		{
			var ret:Boolean = false;
			for(var i:int = 0; i < researchList.length; i++)
			{
				if(researchList[i] is getClass(research)) //if the research item we passed in is the same class as the one we found
				{
					if(researchList[i].isComplete()) //if found and it is complete, return true, afterwards, just break the loop and pass the return value
					{
						ret = true;
					}
					break;
				}
			}
			
			return ret;
		}
		
		//not sure if this works...
		static function getClass(obj:Object):Class
		{
			return Object(obj).constructor; //Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}