package Map         
{
	
	import Buildings.Building;
	
	import Planets.Planet;
	
	import Player.BasePlayer;
	
	import Units.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import main.FogGraphic;
	
	public class MapTile extends MovieClip
	{
		//graph connections
		public var northTile:MapTile;
		public var eastTile:MapTile;
		public var southTile:MapTile;
		public var westTile:MapTile;
		public var ownedPlanet:Planet = null; //the planet this maptile is situated on. If null then it's a space tile.
		
		//coordinates
		public var xCord:int;
		public var yCord:int;
		
		//Used for pathfinding
		public var g:int;
		public var h:int;
		public var parentTile:MapTile;
		
		//Contents of map tile
		public var unit:Unit = null;
		public var building:Building = null;
		public var planet:Planet = null;
		public var directionArrow:MovieClip = null;
		public var mapGraphic:MapGraphic = null;
		public var fogGraphic:FogGraphic = null;
		public var tileName:String = "";
		
		//boolean to verify if unit can move to it. Or to attack it, or is visible
		public var canMove:Boolean = false;
		public var canAttack:Boolean = false;
		public var isVisible:Boolean = false; //basically to be used as a check to see if the unit is visible
		public var checkedForAttack:Boolean = false //used to check for range. so that tiles are only checked once
		
		//Information about tile
		public var information:String = "";
		
		//properties
		public var defenseValue:Number; //defense value of the tile
		public var blocksVision:Boolean = false; //true only if the tile can only be revealed if a unit is right next to it
		public var canBuild:Boolean = true; //false only if not allowed to build buildings on this tile.
		
		public function MapTile()
		{
			super();
		}
		
		//Functions below, add/removes units and buildings to the map tile
		public function addUnit(unitAdded:Unit)
		{
			unit = unitAdded;
			unit.x = 0;//set x and y to 0 so that the unit stays in the center
			unit.y = 0;
			unit.location = this; //set the units location to this map tile
			
			addChild(unit);
		}
		
		public function removeUnit()
		{
			if(unit != null)
			{
				removeChild(unit);
				unit = null;
			}
		}
		
		public function addBuilding(buildingAdded:Building)
		{
			building = buildingAdded;
			addChild(building);
			
			if(hasUnit()) //if the tile has a unit on it. Move the building UNDER the unit on screen
			{
				setChildIndex(unit,2);
				setChildIndex(building,1);
			}
		}
		
		public function removeBuilding()
		{
			if(building != null)
			{
				removeChild(building);
				building = null;
			}
		}
		
		public function addPlanet(planetAdded:Planet)
		{
			planet = planetAdded;
			addChild(planet);
			
			if(hasUnit()) //if the tile has a unit on it. Move the planet UNDER the unit on screen
			{
				setChildIndex(unit,2);
				setChildIndex(planet,1);
			}
		}
		
		public function removePlanet() //I'm going to be honest. I don't know if this will or even SHOULD ever come up, but if it does I will have to do WAY more than what it's actually doing right now (cleanup of owned units and such)
		{
			if(planet != null)
			{
				removeChild(planet);
				planet = null;
			}
		}
		
		public function addDirectionArrow(graphic:MovieClip)
		{
			if(directionArrow == null) //direction arrow SHOULD be null at this point, basically this shouldn't be a problem unless something's gone wrong
			{
				directionArrow = graphic;
				addChild(directionArrow);
			}
			else
			{
				trace("Error: Direction arrow was not null before we were going to add it, check addDirectionArrow in MapTile");
			}
		}
		
		public function removeDirectionArrow()
		{
			if(directionArrow != null)
			{
				removeChild(directionArrow);
				directionArrow = null;
			}
		}
		
		//returns true if this maptile contains a unit
		public function hasUnit():Boolean
		{
			if(unit != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//returns true if this maptile contains a building
		public function hasBuilding():Boolean
		{
			if(building != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//returns true if this maptile contains a planet (Should only be space tiles)
		public function hasPlanet():Boolean
		{
			if(planet != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//highlights tile for movement
		public function showMove()
		{
			if(mapGraphic == null)
			{
				mapGraphic = new MapGraphic();
				addChild(mapGraphic);
			}
			canMove = true;
			this.addEventListener(Event.ENTER_FRAME, keepContentsOnTop);
		}
		
		//removed highlight
		public function stopMove()
		{
			if(mapGraphic != null)
			{
				removeChild(mapGraphic);
				mapGraphic = null;
			}
			canMove = false;
			this.removeEventListener(Event.ENTER_FRAME, keepContentsOnTop);
		}
		
		public function showAttack():void
		{
			if(mapGraphic == null)
			{
				mapGraphic = new MapGraphic();
				mapGraphic.gotoAndPlay("attackAnimation");
				addChild(mapGraphic)
			}
			canAttack = true;
			checkedForAttack = true; //marked as already checked so that it isn't accidentally checked again
			this.addEventListener(Event.ENTER_FRAME, keepContentsOnTop);
		}
		
		public function stopAttack()
		{
			if(mapGraphic != null)
			{
				removeChild(mapGraphic);
				mapGraphic = null;
			}
			canAttack = false;
			checkedForAttack = false; //unmark tile so that it can be marked agian
			this.removeEventListener(Event.ENTER_FRAME, keepContentsOnTop);
		}
		
		//used to mark the tile as checked for attack
		public function checkAttack()
		{
			checkedForAttack = true;
		}
		
		public function addFog(turn:BasePlayer):void //adds fog to the tile, hides content
		{
			if(fogGraphic == null) //if the fog graphic doesn't already exist
			{
				fogGraphic = new FogGraphic();
				addChild(fogGraphic);
			
				if(unit != null) //hides unit if any
				{
					unit.visible = false;
				}
				
				if(building != null) //hides building if any
				{
					var sentinel:Boolean = false; //sentinel to check if the for loop found anything
					
					for(var i:int = 0; i < building.discoveredBy.length; i++)
					{
						if(building.discoveredBy[i] == turn) //if this part of the discoveredBy array is the same as the player who's turn it is. don't hide the building
						{
							building.visible = true;
							sentinel = true;
							i = building.discoveredBy.length + 1; //stop the search
						}
					}
					
					if(!sentinel) //if the search came up with nothing. Hide the building
					{
						building.visible = false;
					}
				}
				
				isVisible = false;
			}
		}
		
		public function removeFog(turn:BasePlayer):void //removes fog from the tile, revealing contents
		{
			if(fogGraphic != null)
			{
				removeChild(fogGraphic);
				fogGraphic = null;
			}
			
			if(unit != null) //reveals unit if any
			{
				unit.visible = true;
			}
			if(building != null) //reveals building if any
			{
				var sentinel:Boolean = false;
				
				for(var i:int = 0; i < building.discoveredBy.length; i++) //going through the discovered by array to see if it's already here. If not, add it
				{
					if(building.discoveredBy[i] == turn)
					{
						sentinel = true;
						i = building.discoveredBy.length + 1; //stop search
					}
				}
				
				if(!sentinel) //if the search found nothing. Add it to the array
				{
					building.discoveredBy.push(turn); //add this player.
				}
				
				building.visible = true;
			}
			
			isVisible = true;
		}
		
		//Function to keep contents of the maptile (units, buildings) on top of the maptile while animations are running.
		public function keepContentsOnTop(e:Event)
		{
			if(unit != null && building != null && planet != null)
			{
				setChildIndex(unit,4);
				setChildIndex(mapGraphic, 3);
				setChildIndex(building,2);
				setChildIndex(planet, 1);
			}
			else if(unit != null && planet != null)
			{
				setChildIndex(unit,3);
				setChildIndex(mapGraphic, 2);
				setChildIndex(planet, 1);
			}
			else if(building != null) //There shouldn't be a planet and building on the same tile
			{
				setChildIndex(mapGraphic, 2);
				setChildIndex(building,1);
			}
			else if(unit != null)
			{
				setChildIndex(unit,2);
				setChildIndex(mapGraphic, 1);
			}
			else if (planet != null)
			{
				setChildIndex(mapGraphic, 2);
				setChildIndex(planet,1);
			}
		}
		
		//clears path finding data so it can be reused afterwards
		public function clearPathData()
		{
			g = null; //possible problem?
			h = null;
			parentTile = null;
		}
		
		public function getCost(unit:Unit):int
		{
			//THIS MUST BE PRESENT IN EVERY TILE
			if(this.hasUnit() && this.unit.player != unit.player && this.isVisible) //if this tile currently contains a unit which is not owned by the current player, AND it is currently visible, then the terrain is impassible (cost 9999)
			{
				return 9999;
			}
			if(this.hasBuilding() && this.building.player != unit.player && !this.building.allowsEnemyMovement) //if this tile contains a building not owned by the player and the building is impassible to enemies, it is impassible (cost 9999)
			{
				return 9999;
			}
			//abstract, defined in each map tile
			return 0;
		}
	}
}