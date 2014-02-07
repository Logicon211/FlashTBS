package Buildings
{
	import ArmorTypes.*;
	
	import Buttons.UnitButton;
	import Buttons.buildButton;
	import Buttons.engineerButton;
	import Buttons.fireButton;
	import Buttons.infantryButton;
	import Buttons.researchButton;
	
	import Map.MapTile;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import main.BuildWindow;
	import Player.BasePlayer;
	
	public class Factory extends Building
	{

		public function Factory()
		{
			super();
			information = "This is a factory for producing units, more info to be added later";
			buildingName = "Factory";
			defenseValue = 3;
			defense = 1; //damage resistance
			armor = new building_medium();
			
			offensiveCapable = true;
			maxRange = 3;
			minRange = 1;
			canAttackGround = true;
			//adding abilities
			
			//cost
			creditCost = 5000;
		}
		
		override public function getAbilities(unitOnTile:Boolean, unitWithinRange:Boolean):Array
		{
			var abilities:Array = new Array();
			if(!unitOnTile) //if there's no unit currently on the same tile
			{
				abilities.push(new buildButton()); //ability to construct units
			}
			if(unitWithinRange && offensiveCapable && !hasFired) //if a units within range and the building is offensive capable, and the building hasn't fired yet
			{
				abilities.push(new fireButton()) //add the ability to fire weapons
			}
			return abilities;
		}
		
		override public function initializeBuildWindow():BuildWindow
		{
			//initialize starting placement values as well as each button to be placed in the menu, will check current research to see if a unit is available
			buildWindow = new BuildWindow();
			var x:int = 30;
			var y:int = 50;
			
			//unit list below
			var infantry = new infantryButton(); //Infantry
			infantry.x = x;
			infantry.y = y;
			infantry.addEventListener(MouseEvent.MOUSE_OVER, showInfo, false, 0, true);
			buildWindow.buttonList.push(infantry);
			buildWindow.addChild(infantry);
			y = y + 40;
			
			var engineer = new engineerButton();
			engineer.x = x;
			engineer.y = y;
			engineer.addEventListener(MouseEvent.MOUSE_OVER, showInfo, false, 0, true);
			buildWindow.buttonList.push(engineer);
			buildWindow.addChild(engineer);
			y = y + 40;
			//add more unit buttons using the type of template above, add research conditions if needed (IE needs to be researched before bought)

			return buildWindow;
		}
		
		public function showInfo(e:Event):void //shows unit info on the right side window
		{
			buildWindow.updateText("------Cost------\nCredit: " + e.target.unit.creditCost + "\nResources: " + e.target.unit.resourceCost);
		}
		
		//for testing. Unless I really want the factory to attack at some point in the future
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
					baseDamage = 9;
				}
				else if(enemyMapTile.unit.armor is building_medium)
				{
					baseDamage = 5;
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
					baseDamage = 9;
				}
				else if(enemyMapTile.building.armor is building_medium)
				{
					baseDamage = 5;
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