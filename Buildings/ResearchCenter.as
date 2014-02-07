package Buildings
{
	import ArmorTypes.building_medium;
	import Player.BasePlayer;
	import Map.MapTile;
		
	import Buttons.researchButton;
	
	public class ResearchCenter extends Building
	{
		public function ResearchCenter()
		{
			super();
			information = "This is a center for generating research, more info to be added later";
			buildingName = "Research Center";
			
			armor = new building_medium();
			defenseValue = 3;
			
			//cost
			//credit cost is variable depending upon the # of research centers on a planet. determined in getCost()
		}
		
		//this function does essentially the same thing as the superclass, except it adds 1 to the number of research centers the player owns
		override public function initializeBuilding(playerOwned:BasePlayer, mapLocation:MapTile) // initializes the building to the owning player and to the location it was built
		{
			player = playerOwned;
			location = mapLocation; //set the location to the initialized location
			
			location.ownedPlanet.addResearch(player.playerNumber); //Add 1 more city to the planet owned by this player.
			
			player.buildingList.push(this); //add this building to the list of currently owned buildings
			
			if(player.playerNumber == 1 && player.race == BasePlayer.HUMAN)
			{
				gotoAndPlay("redIdleHuman");
			}
			else if(player.playerNumber == 1 && player.race == BasePlayer.TECH)
			{
				gotoAndPlay("redIdleTech");
			}
			else if(player.playerNumber == 1 && player.race == BasePlayer.INFECTED)
			{
				gotoAndPlay("redIdleInfected");
			}
			else if(player.playerNumber == 2 && player.race == BasePlayer.HUMAN)
			{
				gotoAndPlay("blueIdleHuman");
			}
			else if(player.playerNumber == 2 && player.race == BasePlayer.TECH)
			{
				gotoAndPlay("blueIdleTech");
			}
			else if(player.playerNumber == 2 && player.race == BasePlayer.INFECTED)
			{
				gotoAndPlay("blueIdleInfected");
			}
			
			player.numResearchCenters = player.numResearchCenters + 1; //add 1 city to the player's total number of cities
		}
		
		override public function getAbilities(unitOnTile:Boolean, unitWithinRange:Boolean):Array
		{
			var abilities:Array = new Array();
			abilities.push(new researchButton());//add the ability to bring the research window up
			
			return abilities;
		}
		
		override public function getCost(tile:MapTile, playerIn:BasePlayer):int
		{
			return 1000 + (1000 * tile.ownedPlanet.getNumResearchCenters(playerIn.playerNumber)); // cost equals 1000 plus 1000 times the number of cities already on the planet owned by the player
		}
		
		//Function to take damage from another unit, if it reaches 0, the building is destroyed and deleted from the maptile it resides
		override public function takeDamage(damage:int):void
		{
			health = health - damage;
			if(health <= 0)
			{
				player.removeBuilding(this); //remove this unit from the player list
				location.ownedPlanet.removeResearch(player.playerNumber)
				location.removeBuilding(); //calls the containing maptile to delete it.
			}
		}
	}
}