package main
	
{
	import Buildings.Building;
	
	import Graphics.*;
	
	import Map.MapTile;
	
	import Player.BasePlayer;
	
	import Units.Unit;
	
	public class Utils
	{
		
		public function Utils()
		{
			//This class is to hold commonly used functions
		}
		
		//shows movement tiles, needs a maptile and how much movement is left. recursive
		public static function showMoveTiles(tile:MapTile, movementLeft:int, unit:Unit):void
		{
			tile.showMove();
			
			if(tile.northTile != null && movementLeft -tile.northTile.getCost(unit) >= 0)
			{
				showMoveTiles(tile.northTile, movementLeft - tile.northTile.getCost(unit), unit);
			}
			if(tile.eastTile != null && movementLeft - tile.eastTile.getCost(unit) >= 0)
			{
				showMoveTiles(tile.eastTile, movementLeft - tile.eastTile.getCost(unit), unit);
			}
			if(tile.southTile != null && movementLeft - tile.southTile.getCost(unit) >= 0)
			{
				showMoveTiles(tile.southTile, movementLeft - tile.southTile.getCost(unit), unit);
			}
			if(tile.westTile != null && movementLeft - tile.westTile.getCost(unit) >= 0)
			{
				showMoveTiles(tile.westTile, movementLeft - tile.westTile.getCost(unit), unit);
			}
		}
		
		//removes the movement tile animation from the point of origin
		public static function removeMoveTiles(tile:MapTile, movementLeft:int, unit:Unit):void
		{
			tile.stopMove();
			
			if(tile.northTile != null && movementLeft -tile.northTile.getCost(unit) >= 0)
			{
				removeMoveTiles(tile.northTile, movementLeft - tile.northTile.getCost(unit), unit);
			}
			if(tile.eastTile != null && movementLeft - tile.eastTile.getCost(unit) >= 0)
			{
				removeMoveTiles(tile.eastTile, movementLeft - tile.eastTile.getCost(unit), unit);
			}
			if(tile.southTile != null && movementLeft - tile.southTile.getCost(unit) >= 0)
			{
				removeMoveTiles(tile.southTile, movementLeft - tile.southTile.getCost(unit), unit);
			}
			if(tile.westTile != null && movementLeft - tile.westTile.getCost(unit) >= 0)
			{
				removeMoveTiles(tile.westTile, movementLeft - tile.westTile.getCost(unit), unit);
			}
		}
		
		//similar to show move tiles, this is to check for enemy units and show the attack tile animation
		public static function showAttackTiles(tile:MapTile, rangeLeft:int, minRange:int, unit:Unit = null, building:Building = null):void
		{
			if(unit != null) //if we're checking for a unit and the tile hasn't been checked already
			{
				if(rangeLeft >= 0) //if the tile has a unit (or building) which is not on the current players team and the selected unit can attack this unit, and the tile is visible, and current range is equal to or greater than 0
				{
					if(!tile.checkedForAttack) //if we're under minimum range, show attack
					{
						tile.showAttack();
					}
					
					if(minRange >= 0) //if within min range, remove the attack tile
					{
						tile.stopAttack();
					}
					tile.checkAttack(); //mark the tile as checked regardless
					
					if(tile.northTile != null)
					{
						showAttackTiles(tile.northTile, rangeLeft - 1, minRange - 1, unit);
					}
					if(tile.eastTile != null)
					{
						showAttackTiles(tile.eastTile, rangeLeft - 1, minRange - 1, unit);
					}
					if(tile.southTile != null)
					{
						showAttackTiles(tile.southTile, rangeLeft - 1, minRange - 1, unit);
					}
					if(tile.westTile != null)
					{
						showAttackTiles(tile.westTile, rangeLeft - 1, minRange - 1, unit);
					}
				}
			}
			else if(building != null) //if we're checking for a building
			{
				if(rangeLeft >= 0) //if the tile has a unit (or building) which is not on the current players team and the selected unit can attack this unit, and the tile is visible, and current range is equal to or greater than 0
				{
					if(!tile.checkedForAttack) //If the tile wasn't checked already
					{
						tile.showAttack();
					}
					
					if(minRange >= 0) //if within min range, remove the attack tile
					{
						tile.stopAttack();
					}
					tile.checkAttack(); //mark the tile as checked regardless
					
					if(tile.northTile != null) 
					{
						showAttackTiles(tile.northTile, rangeLeft - 1, minRange - 1, null, building);
					}
					if(tile.eastTile != null)
					{
						showAttackTiles(tile.eastTile, rangeLeft - 1, minRange - 1, null, building);
					}
					if(tile.southTile != null)
					{
						showAttackTiles(tile.southTile, rangeLeft - 1, minRange - 1, null, building);
					}
					if(tile.westTile != null)
					{
						showAttackTiles(tile.westTile, rangeLeft - 1, minRange - 1, null, building);
					}
				}
			}
		}
		
		//removes the attack tile animation
		public static function removeAttackTiles(tile:MapTile, rangeLeft:int, unit:Unit = null, building:Building = null):void
		{
			if(unit != null)
			{
				if (rangeLeft >= 0) //if the tile has a unit which is not on the current players team and the selected unit can attack this unit and current range is equal to or greater than 0
				{
					tile.stopAttack();
					
					if(tile.northTile != null)
					{
						removeAttackTiles(tile.northTile, rangeLeft - 1, unit);
					}
					if(tile.eastTile != null)
					{
						removeAttackTiles(tile.eastTile, rangeLeft - 1, unit);
					}
					if(tile.southTile != null)
					{
						removeAttackTiles(tile.southTile, rangeLeft - 1, unit);
					}
					if(tile.westTile != null)
					{
						removeAttackTiles(tile.westTile, rangeLeft - 1, unit);
					}
				}
			}
			else if(building != null)
			{
				if(rangeLeft >= 0) //if the tile has a unit which is not on the current players team and the selected unit can attack this unit and current range is equal to or greater than 0
				{
					tile.stopAttack();
					
					if(tile.northTile != null)
					{
						removeAttackTiles(tile.northTile, rangeLeft - 1, null, building);
					}
					if(tile.eastTile != null)
					{
						removeAttackTiles(tile.eastTile, rangeLeft - 1, null, building);
					}
					if(tile.southTile != null)
					{
						removeAttackTiles(tile.southTile, rangeLeft - 1, null, building);
					}
					if(tile.westTile != null)
					{
						removeAttackTiles(tile.westTile, rangeLeft - 1, null, building);
					}
				}
			}
		}
		
		public static function showMoveLines(shortestPath:Array, map:Array) //this function is exceedingly long, may be best to keep it non-collapsed
		{
			var temp1:MapTile;
			var temp2:MapTile;
			
			for(var g=shortestPath.length - 1; g>=0; g--) 
			{
				/* 
				for loop to draw the correct arrows for the path.
				temp 1 is the MapTile that is the one previous to our current target
				temp 2 is the MapTile previous to temp 1
				*/
				if(g == shortestPath.length - 1)  //If we've just started, assign temp1 as our current target
				{
					temp1 = shortestPath[g];
				}
				else if(g == 0) //finish with an arrow
				{
					if(shortestPath.length <= 2)
					{
						temp2 = temp1;
					}
					
					//even though we're finihsing with an arrow, we still need to draw whatever is on temp1 (this is a copy)
					if(temp1.northTile != null && shortestPath[g] == temp1.northTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							temp1.addDirectionArrow(new upDownConnector);
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							temp1.addDirectionArrow(new leftUpConnector);
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							//shouldn't happen
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							temp1.addDirectionArrow(new rightUpConnector);
						}
					}
					else if(temp1.eastTile != null && shortestPath[g] == temp1.eastTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							temp1.addDirectionArrow(new rightDownConnector);
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							temp1.addDirectionArrow(new leftRightConnector);
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							temp1.addDirectionArrow(new rightUpConnector);
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							//shouldn't happen
						}
					}
					else if(temp1.southTile != null && shortestPath[g] == temp1.southTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							//shouldn't happen
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							temp1.addDirectionArrow(new leftDownConnector);
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							temp1.addDirectionArrow(new upDownConnector);
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							temp1.addDirectionArrow(new rightDownConnector);
						}
					}
					else if(temp1.westTile != null && shortestPath[g] == temp1.westTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							temp1.addDirectionArrow(new leftDownConnector);
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							//shouldn't happen
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							temp1.addDirectionArrow(new leftUpConnector);
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							temp1.addDirectionArrow(new leftRightConnector);
						}
					}
					
					//if else block to draw the arrow
					if(temp1.northTile != null && shortestPath[g] == temp1.northTile)
					{
						shortestPath[g].addDirectionArrow(new upArrow);
					}
					else if(temp1.eastTile != null && shortestPath[g] == temp1.eastTile)
					{
						shortestPath[g].addDirectionArrow(new leftArrow);
					}
					else if(temp1.southTile != null && shortestPath[g] == temp1.southTile)
					{
						shortestPath[g].addDirectionArrow(new downArrow);
					}
					else if(temp1.westTile != null && shortestPath[g] == temp1.westTile)
					{
						shortestPath[g].addDirectionArrow(new rightArrow);
					}
				}
				else if(g == shortestPath.length - 2) //If we've gone twice through the block, assign reassign temp 1, and assign temp 2
				{
					temp1 = shortestPath[g];
					temp2 = shortestPath[g + 1];
				}
				else //draw the correct arrow block according to the locations of our target and temp1 and temp2
				{
					if(temp1.northTile != null && shortestPath[g] == temp1.northTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							temp1.addDirectionArrow(new upDownConnector);
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							temp1.addDirectionArrow(new leftUpConnector);
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							//shouldn't happen
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							temp1.addDirectionArrow(new rightUpConnector);
						}
					}
					else if(temp1.eastTile != null && shortestPath[g] == temp1.eastTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							temp1.addDirectionArrow(new rightDownConnector);
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							temp1.addDirectionArrow(new leftRightConnector);
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							temp1.addDirectionArrow(new rightUpConnector);
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							//shouldn't happen
						}
					}
					else if(temp1.southTile != null && shortestPath[g] == temp1.southTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							//shouldn't happen
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							temp1.addDirectionArrow(new leftDownConnector);
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							temp1.addDirectionArrow(new upDownConnector);
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							temp1.addDirectionArrow(new rightDownConnector);
						}
					}
					else if(temp1.westTile != null && shortestPath[g] == temp1.westTile)
					{
						if(temp2.northTile != null && temp1 == temp2.northTile)
						{
							temp1.addDirectionArrow(new leftDownConnector);
						}
						else if(temp2.eastTile != null && temp1 == temp2.eastTile)
						{
							//shouldn't happen
						}
						else if(temp2.southTile != null && temp1 == temp2.southTile)
						{
							temp1.addDirectionArrow(new leftUpConnector);
						}
						else if(temp2.westTile != null && temp1 == temp2.westTile)
						{
							temp1.addDirectionArrow(new leftRightConnector);
						}
					}
					temp1 = shortestPath[g]; //reassign temp variables
					temp2 = shortestPath[g+1];
				}
			}
			
			//This may be too expencive depending on the size of the map. Seems to work fine on a 30x40 though
			for(var i = 0; i < map.length ;i++){ //Heigth
				for(var j = 0; j < map[0].length ;j++) { //Width
					map[i][j].clearPathData(); //clears path finding data
				}
			}
		}
		
		public static function removeMoveLines(shortestPath:Array)
		{
			/*for(var i = 0; i < map.length ;i++){ //Heigth
			for(var j = 0; j < map[0].length ;j++) { //Width
			map[i][j].removeDirectionArrow(); //clears path finding data
			}
			}*/
			//^^This is too expencive for how much it will be used.
			
			for(var i:int = 0; i < shortestPath.length; i++)
			{
				shortestPath[i].removeDirectionArrow();
			}
		}
		
		//revursively reveal tiles in fog of war
		public static function revealFog(tile:MapTile, vision:int, turn:BasePlayer):void
		{
			if(vision >= 0) //check whats left of vision, we check the 0 value as well because the unit or building will reveal the tile it is currently in as well
			{
				if(tile.blocksVision) //if the tile blocks vision, check for adjacent units
				{
					if((tile.hasUnit() && tile.unit.player == turn) || (tile.hasBuilding() && tile.building.player == turn)) //if the tile has a unit or building, and the unit or building is on the player whos turn it is team
					{
						tile.removeFog(turn);
					}
					else if(tile.northTile != null && tile.northTile.hasUnit() && tile.northTile.unit.player == turn) //check northtile
					{
						tile.removeFog(turn);
					}
					else if(tile.eastTile != null && tile.eastTile.hasUnit() && tile.eastTile.unit.player == turn) //check easttile
					{
						tile.removeFog(turn);
					}
					else if(tile.southTile != null && tile.southTile.hasUnit() && tile.southTile.unit.player == turn) //check southtile
					{
						tile.removeFog(turn);
					}
					else if(tile.westTile != null && tile.westTile.hasUnit() && tile.westTile.unit.player == turn) //check westtile
					{
						tile.removeFog(turn);
					}
				}
				else //If the tile doesn't block vision, no need to check, just reveal the tile
				{
					tile.removeFog(turn);
				}
				
				//check adjacent tiles minus 1 vision, check if tiles exist first
				if(tile.northTile != null)
				{
					revealFog(tile.northTile, vision - 1, turn);
				}
				if(tile.eastTile != null)
				{
					revealFog(tile.eastTile, vision - 1, turn);
				}
				if(tile.southTile != null)
				{
					revealFog(tile.southTile, vision - 1, turn);
				}
				if(tile.westTile != null)
				{
					revealFog(tile.westTile, vision - 1, turn);
				}
			}
		}
		
		public static function testRange(mapTile:MapTile, range:int, attackingUnit:Unit, turn:BasePlayer, unitToTest:Unit = null):Boolean //checks to see if an enemy unit is within range (And is attackable by selected unit), Can also check to see if an specific unit is within range, recursive function. Used to check minimum ranges as well.
		{
			if(range < 0 ) //If we're out of range, stop checking tiles and return false
			{
				return false;
			}
			else if(((mapTile.hasUnit() && attackingUnit.canAttack(mapTile.unit) && mapTile.unit.player != turn) || (mapTile.hasBuilding() && attackingUnit.canAttackBuildings() && mapTile.building.player != turn)) && mapTile.isVisible) //if there is a unit within range, or a building within range, and the tile is visible, immediately stop and return true
			{
				if(unitToTest == null) //if there is no unit to look for. Then return true as it is a general search
				{
					return true;
				}
				else if(unitToTest == mapTile.unit) //if this unit is the one we're looking for, return true
				{
					return true;
				}
				else //if either of the above aren't true, return false
				{
					return false;
				}
			}
			else //if the current tile doesn't have a unit, recursively check each adjacent tile for units until we run out of range
			{
				//these variables are for the 4 adjacent squares, and the 5th one to summarize them all into one.
				var temp1:Boolean;
				var temp2:Boolean;
				var temp3:Boolean;
				var temp4:Boolean;
				var temp5:Boolean;
				
				if(mapTile.northTile != null)
				{
					temp1 = testRange(mapTile.northTile, range - 1, attackingUnit, turn, unitToTest);
				}
				else
				{
					temp1 = false;
				}
				
				if(mapTile.eastTile != null)
				{
					temp2 = testRange(mapTile.eastTile, range - 1, attackingUnit, turn, unitToTest);
				}
				else
				{
					temp2 = false;
				}
				
				if(mapTile.southTile != null)
				{
					temp3 = testRange(mapTile.southTile, range - 1, attackingUnit, turn, unitToTest);
				}
				else
				{
					temp3 = false;
				}
				
				if(mapTile.westTile != null)
				{
					temp4 = testRange(mapTile.westTile, range - 1, attackingUnit, turn, unitToTest);
				}
				else
				{
					temp4 = false
				}
				
				if(temp1 || temp2 || temp3 || temp4)
				{
					temp5 = true;
				}
				else
				{
					temp5 = false;
				}
				
				return temp5;
			}
		}
		
		//checks to see if an enemy unit is within range FOR BUILDINGS (And is attackable by selected unit), Can also check to see if an specific unit is within range, recursive function
		public static function testBuildingRange(mapTile:MapTile, range:int, attackingBuilding:Building, turn:BasePlayer):Boolean
		{
			if(range < 0) //If we're out of range, stop checking tiles and return false
			{
				return false;
			}
			else if(((mapTile.hasUnit() && attackingBuilding.canAttack(mapTile.unit) && mapTile.unit.player != turn) || (mapTile.hasBuilding() && attackingBuilding.canAttackBuildings() && mapTile.building.player != turn)) && mapTile.isVisible) //if there is a unit within range, or a building within range, and the tile is visible, immediately stop and return true
			{
				return true;
			}
			else //if the current tile doesn't have a unit, recursively check each adjacent tile for units until we run out of range
			{
				//these variables are for the 4 adjacent squares, and the 5th one to summarize them all into one.
				var temp1:Boolean;
				var temp2:Boolean;
				var temp3:Boolean;
				var temp4:Boolean;
				var temp5:Boolean;
				
				if(mapTile.northTile != null)
				{
					temp1 = testBuildingRange(mapTile.northTile, range - 1, attackingBuilding, turn);
				}
				else
				{
					temp1 = false;
				}
				
				if(mapTile.eastTile != null)
				{
					temp2 = testBuildingRange(mapTile.eastTile, range - 1, attackingBuilding, turn);
				}
				else
				{
					temp2 = false;
				}
				
				if(mapTile.southTile != null)
				{
					temp3 = testBuildingRange(mapTile.southTile, range - 1, attackingBuilding, turn);
				}
				else
				{
					temp3 = false;
				}
				
				if(mapTile.westTile != null)
				{
					temp4 = testBuildingRange(mapTile.westTile, range - 1, attackingBuilding, turn);
				}
				else
				{
					temp4 = false
				}
				
				if(temp1 || temp2 || temp3 || temp4)
				{
					temp5 = true;
				}
				else
				{
					temp5 = false;
				}
				
				return temp5;
			}
		}
		
		//Checks to see if a tile can be attacked
		public static function canAttackTile(tileToBeAttacked:MapTile, turn:BasePlayer, attackingUnit:Unit = null, attackingBuilding:Building = null):Boolean
		{
			if(attackingUnit != null) //if the attacking entity is a unit
			{
				if(tileToBeAttacked.hasUnit()) //if the tile we're attacking has a unit, attack that first
				{
					if(tileToBeAttacked.unit.player != turn && attackingUnit.canAttack(tileToBeAttacked.unit) && tileToBeAttacked.isVisible) //if the defending unit isn't a part of the current player's turn, the attacking unit can attack the type of defender, and the tile is visible
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else if (tileToBeAttacked.hasBuilding()) //if not, then its a building
				{	
					if(tileToBeAttacked.building.player != turn && attackingUnit.canAttackBuildings() && tileToBeAttacked.isVisible) //if the defending unit isn't a part of the current player's turn, the attacking unit can attack buildings, and the tile is visible
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			else if(attackingBuilding != null) //if the attacking entity is a building
			{
				if(tileToBeAttacked.hasUnit()) //if the tile we're attacking has a unit, attack that first
				{
					if(tileToBeAttacked.unit.player != turn && attackingBuilding.canAttack(tileToBeAttacked.unit) && tileToBeAttacked.isVisible) //if the defending unit isn't a part of the current player's turn, the attacking unit can attack the type of defender, and the tile is visible
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else if (tileToBeAttacked.hasBuilding()) //if not, then its a building
				{	
					if(tileToBeAttacked.building.player != turn && attackingBuilding.canAttackBuildings() && tileToBeAttacked.isVisible) //if the defending unit isn't a part of the current player's turn, the attacking unit can attack buildings, and the tile is visible
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			return false; //needed for the compiler, shouldn't happen
		}
		
		//fills the map in fog and recalculates vision
		public static function calculateVision(map:Array, turn:BasePlayer):void
		{
			for(var i = 0; i < map.length ;i++){ //Heigth
				for(var j = 0; j < map[0].length ;j++) { //Width
					map[i][j].addFog(turn); //adds fog to the whole map. Passes the player whose turn it is so that we can figure out which buildings haven't been discovered yet
				}
			}
			
			for(i = 0; i < map.length ;i++){ //Heigth
				for(j = 0; j < map[0].length ;j++) { //Width
					
					if(map[i][j].hasUnit() && map[i][j].unit.player == turn) //if tile has a unit which is owned by the player whos turn it is. calculate vision revealing
					{
						Utils.revealFog(map[i][j], map[i][j].unit.vision, turn); //reveal fog starting from that tile using the units vision
					}
					if(map[i][j].hasBuilding() && map[i][j].building.player == turn) //if tile has a unit which is owned by the player whos turn it is. calculate vision revealing
					{
						Utils.revealFog(map[i][j], map[i][j].building.vision, turn); //reveal fog starting from that tile using the units vision
					}
				}
			}
		}
	}
}