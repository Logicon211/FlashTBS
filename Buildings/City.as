package Buildings
{
	import ArmorTypes.building_medium;
	
	import Map.MapTile;
	
	import Player.BasePlayer;
	
	public class City extends Building
	{
		public function City()
		{
			super();
			information = "This is a city for generating income, more info to be added later";
			buildingName = "City";
			
			armor = new building_medium();
			defenseValue = 3;
			
			//cost
			//credit cost is variable depending upon the # of cities on a planet. determined in getCost()
		}
		
		//this function does essentially the same thing as the superclass, except it adds 1 to the number of cities the player owns
		override public function initializeBuilding(playerOwned:BasePlayer, mapLocation:MapTile) // initializes the building to the owning player and to the location it was built
		{
			player = playerOwned;
			location = mapLocation; //set the location to the initialized location
			
			location.ownedPlanet.addCity(player.playerNumber); //Add 1 more city to the planet owned by this player.
			
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
			
			player.numCities = player.numCities + 1; //add 1 city to the player's total number of cities
		}
		
		override public function getCost(tile:MapTile, playerIn:BasePlayer):int
		{
			return 1000 + (1000 * tile.ownedPlanet.getNumCities(playerIn.playerNumber)); // cost equals 1000 plus 1000 times the number of cities already on the planet owned by the player
		}
		
		//Function to take damage from another unit, if it reaches 0, the building is destroyed and deleted from the maptile it resides
		override public function takeDamage(damage:int):void
		{
			health = health - damage;
			if(health <= 0)
			{
				player.removeBuilding(this); //remove this unit from the player list
				location.ownedPlanet.removeCity(player.playerNumber)
				location.removeBuilding(); //calls the containing maptile to delete it.
			}
		}
	}
}