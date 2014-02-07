package Buildings
{
	import ArmorTypes.Armor;
	
	import Map.MapTile;
	
	import Player.BasePlayer;
	
	import Units.CopterUnit;
	import Units.GroundUnit;
	import Units.PlaneUnit;
	import Units.SeaUnit;
	import Units.SpaceUnit;
	import Units.Unit;
	
	import flash.display.MovieClip;
	
	import main.BuildWindow;
	
	
	public class Building extends MovieClip
	{
		// Buildings cannot be placed in forests, or other tiles which "block vision:
		public var allowsEnemyMovement:Boolean = true;
		public var information:String = "";
		public var buildingName:String = "";
		
		public var armor:Armor; //armor type of the building
		public var defenseValue:int = 0; //defensive value it would give to units on the tile
		public var vision:int = 0; //buildings vision range
		public var health:int = 20;//buildings starting health
		public var maxHealth:int = 20; //maximum possible health, used to check for damage
		public var defense:Number = 0.0; //damage resistance of the building
		
		public var offensiveCapable:Boolean = false;
		public var maxRange:int = 0; //default to 0 because offensive capability is also defaulted to no.
		public var minRange:int = -1// unit minimum range, -1 so that it can still target the tile its on
		public var hasFired:Boolean = false; //goes true when it fires in a turn.
		
		//types of units this unit can attack. Add more if more unit types become available
		public var canAttackGround:Boolean = false;
		public var canAttackPlane:Boolean = false;
		public var canAttackCopter:Boolean = false;
		public var canAttackSea:Boolean = false;
		public var canAttackSpace:Boolean = false;
		
		var creditCost:int = 0; //NOT PUBLIC, using a getCost() to return it
		public var resourceCost:int = 0;
		
		public var player:BasePlayer; //which player owns this building
		public var location:MapTile; //where the building is located, may need to use object class later
		public var discoveredBy:Array = new Array(); //array to store who has discovered this building. Will store Players
		
		public var buildWindow:BuildWindow; //Window which pops up when prompted to build a unit. Only used for buildings which can construct
		
		//other important info goes here or in subclasses, like health and such
		
		public function Building()
		{
			super();
		}
		
		public function initializeBuilding(playerOwned:BasePlayer, mapLocation:MapTile) // initializes the building to the owning player and to the location it was built
		{
			player = playerOwned;
			location = mapLocation; //set the location to the initialized location
			
			player.buildingList.push(this); //add this building to the list of currently owned buildings
			
			if(player.playerNumber == 1)
			{
				gotoAndPlay("redIdle");
			}
			else if(player.playerNumber == 2)
			{
				gotoAndPlay("blueIdle");
			}
		}
		
		public function getAbilities(unitOnTile:Boolean, unitWithinRange:Boolean /*may add other conditions later*/):Array
		{
			var abilities:Array = new Array() //retunr empty array if the building has no abilities . overwrite in the subclass if so
			return abilities;
		}
		
		public function getCost(tile:MapTile, playerIn:BasePlayer):int
		{
			return creditCost;
		}
		
		public function getResourceCost(tile:MapTile, playerIn:BasePlayer):int
		{
			return resourceCost;
		}
		
		public function initializeBuildWindow():BuildWindow//this is to be overwritten by buildings which can construct, it should contain different units for each type of building facility
		{
			trace("Error: initialize build window is being called by a building which cannot build units");
			return buildWindow;
		}
		
		public function clearBuildWindow():void //this function clears the build window
		{
			buildWindow = null;
		}
		
		//Function to take damage from another unit, if it reaches 0, the building is destroyed and deleted from the maptile it resides
		public function takeDamage(damage:int):void
		{
			health = health - damage;
			if(health <= 0)
			{
				player.removeBuilding(this); //remove this unit from the player list
				location.removeBuilding(); //calls the containing maptile to delete it.
			}
		}
		
		//Damage will default be 0 unless offensiveCapable is true, in which case it will be on a building by building basis
		public function calculateDamage(enemyMapTile:MapTile):int
		{
			//General formula will be:
			// ((Base Damage vs Armor type / ((Defense of tile x2 / 10) + 1)) x health/maxhealth) - Enemy Defense value/(Enemy Unit Health / enemyMaxHealth)  ---- All rounded to the nearest, 1.5 goes down(?)
			return 0;
		}
		
		public function canFire():Boolean //returns if the building can fire or not.
		{
			return !hasFired; //if it has fired, then it returns false, if not, return true
		}
		
		public function firedWeapon():void //sets the building to have fired its weapon
		{
			hasFired = true; //Building has now fired
		}
		
		public function renewTurn() //renew turn (for firing the gun mostly
		{
			hasFired = false;
		}
		
		public function canAttack(unit:Unit):Boolean
		{
			//return the canAttack variables depending on unit type
			if(unit is GroundUnit)
			{
				return canAttackGround;
			}
			else if(unit is PlaneUnit)
			{
				return canAttackPlane;
			}
			else if(unit is CopterUnit)
			{
				return canAttackCopter;
			}
			else if(unit is SeaUnit)
			{
				return canAttackSea;
			}
			else if(unit is SpaceUnit)
			{
				return canAttackSpace;
			}
			else //shouldnt happen, but its needed for the compiler
			{
				return false;
			}
		}
		
		//just a simple ground attack check so that we can mark buildings for attack
		public function canAttackBuildings():Boolean
		{
			return canAttackGround;
		}
	}
}