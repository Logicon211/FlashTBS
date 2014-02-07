package Units
{
	import ArmorTypes.*;
	
	import Buttons.attackButton;
	import Buttons.cityButton;
	import Buttons.constructButton;
	import Buttons.factoryButton;
	import Buttons.researchCenterButton;
	import Buttons.resourceCollectorButton;
	
	import Map.ForestTile;
	import Map.MapTile;
	import Map.ResourceTile;
	
	import MovementTypes.Foot;
	
	import Player.BasePlayer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import main.BuildWindow;

	public class Engineer extends GroundUnit
	{
		
		public function Engineer()
		{
			super();
			
			movement = 3;
			maxRange = 1; 
			vision = 3;
			moveType = new Foot(); //foot movement
			armor = new infantry_light();
			defense = 0.4;
			
			unitName = "Engineer";
			information = "This is an Engineer unit. More info will be added later";
			
			creditCost = 2000;
			resourceCost = 0;
			
			//Engineers can attack ground and copters
			canAttackGround = true;
		}
		
		override public function getAbilities(enemyWithinRange:Boolean, tile:MapTile):Array
		{
			var abilities:Array = new Array();
			//removed the attack button as it was arbitrary
			if(tile.canBuild && !tile.hasBuilding())//If the tile allows construction
			{
				abilities.push(new constructButton()); //add the construct button
			}
			
			if(tile is ResourceTile && !tile.hasBuilding()) //if this is a resource collection point
			{
				abilities.push(new resourceCollectorButton()); //add resource collector construction button
			}
			
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
					baseDamage = 4;
				}
				else if(enemyMapTile.unit.armor is building_medium)
				{
					baseDamage = 5;
				}
				else
				{
					baseDamage = 0; //more types to come
				}
				
				damageDealt = Math.round(((baseDamage/(((defenseValue*2)/10) + 1)) * (health/maxHealth)) - (enemyMapTile.unit.defense * (enemyMapTile.unit.health/enemyMapTile.unit.maxHealth)));
			}
				//else it has a building (It has to or else it shouldnt be able to be attacked anyways)
			else if(enemyMapTile.hasBuilding() && enemyMapTile.building.player != player)
			{
				
				if(enemyMapTile.building.armor is infantry_light)
				{
					baseDamage = 4;
				}
				else if(enemyMapTile.building.armor is building_medium)
				{
					baseDamage = 5;
				}
					
				damageDealt = Math.round(((baseDamage/(((defenseValue*2)/10) + 1)) * (health/maxHealth)) - (enemyMapTile.building.defense * (enemyMapTile.building.health/enemyMapTile.building.maxHealth)))
			}
			
			return damageDealt;
		}
		
		override public function initializeBuildWindow():BuildWindow //unique for builders, will return a list of buildings capable of being build
		{
			buildWindow = new BuildWindow();
			var x:int = 30;
			var y:int = 50;
			
			//building list below
			var city = new cityButton(); //City
			city.x = x;
			city.y = y;
			city.addEventListener(MouseEvent.MOUSE_OVER, showInfo, false, 0, true);
			buildWindow.buttonList.push(city);
			buildWindow.addChild(city);
			y = y + 40;
			
			var factory = new factoryButton(); //factory
			factory.x = x;
			factory.y = y;
			factory.addEventListener(MouseEvent.MOUSE_OVER, showInfo, false, 0, true);
			buildWindow.buttonList.push(factory);
			buildWindow.addChild(factory);
			y = y + 40;
			
			var researchCenter = new researchCenterButton(); //factory
			researchCenter.x = x;
			researchCenter.y = y;
			researchCenter.addEventListener(MouseEvent.MOUSE_OVER, showInfo, false, 0, true);
			buildWindow.buttonList.push(researchCenter);
			buildWindow.addChild(researchCenter);
			y = y + 40;
			
			return buildWindow;
		}
		
		public function showInfo(e:Event):void //shows unit info on the right side window
		{
			buildWindow.updateText("------Cost------\nCredit: " + e.target.building.getCost(location, player) + "\nResources: " + e.target.building.getResourceCost(location, player));
		}
	}
}