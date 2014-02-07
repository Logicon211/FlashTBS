package Units  
{
	import ArmorTypes.*;
	
	import Buttons.attackButton;
	
	import Map.MapTile;
	
	import MovementTypes.Foot;
	
	import Player.BasePlayer;
	
	import Research.HumanInfantryUpgrade;

	public class Infantry extends GroundUnit
	{
		public function Infantry()
		{
			super();
			
			movement = 5;
			maxRange = 3;
			vision = 3;
			moveType = new Foot(); //foot movement
			armor = new infantry_light();
			defense = 0.8;

			
			unitName = "Infantry";
			information = "This is an Infantry unit. More info will be added later";
			
			creditCost = 1000;
			resourceCost = 10;
			
			//Infantry can attack ground and copters
			canAttackGround = true;
			canAttackCopter = true;
		}
		override public function getUpgrades():void
		{
			if(player.isResearchObjectComplete(new HumanInfantryUpgrade())) //test to see if newly constructed units gain building armor as well
			{
					armor = new building_medium();
			}
		}
		
		override public function getAbilities(enemyWithinRange:Boolean, tile:MapTile):Array
		{
			var abilities:Array = new Array();
			//removed the attack button as it was arbitrary
			
			return abilities;
		}
		
		override public function calculateDamage(enemyMapTile:MapTile):int
		{
			var defenseValue:Number;
			var damageDealt:int = 0; //return value at the end
			var baseDamage:Number; //to be swapped out for base damage on each type of armor
			
			//If the maptile has a building on it, use it's defense value instead
			if(enemyMapTile.hasBuilding())
			{
				defenseValue = enemyMapTile.building.defenseValue;
			}
			else
			{
				defenseValue = enemyMapTile.defenseValue;
			}
			
			//if the tile has an enemy unit, do damage to it.
			if(enemyMapTile.hasUnit() && enemyMapTile.unit.player != player) 
			{
				//calculate base damage based on enemy armor type
				if(enemyMapTile.unit.armor is infantry_light)
				{
					baseDamage = 6;
				}
				else if(enemyMapTile.unit.armor is building_medium)
				{
					baseDamage = 2;
				}
				else
				{
					baseDamage = 0; //more types to come
				}
				
				//these are temporary for testing at the moment
				var temp:Number = ((baseDamage/(((defenseValue*2)/10) + 1)) * (health/maxHealth)) - (enemyMapTile.unit.defense * (enemyMapTile.unit.health/enemyMapTile.unit.maxHealth));
				trace("Damage done before rounding " + temp);
				
				damageDealt = Math.round(temp);
				trace("Damage done after rounding " + damageDealt)
			}
			//else it has a building (It has to or else it shouldnt be able to be attacked anyways)
			else if(enemyMapTile.hasBuilding() && enemyMapTile.building.player != player)
			{
				
				if(enemyMapTile.building.armor is infantry_light)
				{
					baseDamage = 6;
				}
				else if(enemyMapTile.building.armor is building_medium)
				{
					baseDamage = 2;
				}
				
				var temp:Number = ((baseDamage/(((defenseValue*2)/10) + 1)) * (health/maxHealth)) - (enemyMapTile.building.defense * (enemyMapTile.building.health/enemyMapTile.building.maxHealth));
				trace("Damage done before rounding " + temp);
				
				damageDealt = Math.round(temp);
				trace("Damage done after rounding " + damageDealt)
			}
			
			return damageDealt;
		}
	}
}