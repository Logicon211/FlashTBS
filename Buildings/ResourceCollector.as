package Buildings
{
	import ArmorTypes.building_medium;
	
	import Map.MapTile;
	
	import Player.BasePlayer;
	
	public class ResourceCollector extends Building
	{
		public function ResourceCollector()
		{
			super();
			information = "This is a Resource Collector for generating resources, more info to be added later";
			buildingName = "Collector";
			
			armor = new building_medium();
			defenseValue = 3;
			
			creditCost = 5000; //arbitrary. cost is never taken out. Resource points are free
		}
		
		//this function does essentially the same thing as the superclass, except it adds 1 to the number of resouce collectors on the planet that the player owns
		override public function initializeBuilding(playerOwned:BasePlayer, mapLocation:MapTile) // initializes the building to the owning player and to the location it was built
		{
			player = playerOwned;
			location = mapLocation; //set the location to the initialized location
			
			location.ownedPlanet.addResourcePoint(player.playerNumber); //Add 1 more resource point to the planet owned by this player.
			
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
			
		}
		
		//Function to take damage from another unit, if it reaches 0, the building is destroyed and deleted from the maptile it resides
		override public function takeDamage(damage:int):void
		{
			health = health - damage;
			if(health <= 0)
			{
				player.removeBuilding(this); //remove this unit from the player list
				location.ownedPlanet.removeResourcePoint(player.playerNumber)
				location.removeBuilding(); //calls the containing maptile to delete it.
			}
		}
	}
}