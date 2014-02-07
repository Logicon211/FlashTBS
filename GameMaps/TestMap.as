package GameMaps
{
	import Buildings.*;
	
	import Map.*;
	
	import Planets.Planet;
	import Planets.TestPlanet;
	
	import Units.*;
	
	public class TestMap extends GameMap
	{
		public function TestMap()
		{
			super();
			width = 32;
			height = 32;
		}
		
		public override function ConstructMap(numPlayers:int, players:Array):Array
		{
			trace("Building map...")
			map = new Array();
			
			for(var k:Number = 0;k < 32;k++) { //declaring 2D array, limits of k is the height of the map
				map[k] = new Array();
			}
			
			//Setting up a temp all grass map and some forest for tests, this will defenitely change
			for(var i:Number = 0;i < 32;i++){ //Heigth
				for(var j:Number = 0;j < 32;j++) { //Width
					
					// Just a plain empty space map
					map[i][j] = new SpaceTile();
					
					map[i][j].xCord = j;
					map[i][j].yCord = i;
					map[i][j].x = (map[i][j].width *(j));
					map[i][j].y = (map[i][j].height *(i));
				}
			}
			
			//Setting up connections to each maptile
			for(i=0; i<map.length; i++){
				for(j=0; j<map[0].length; j++){
					
					//checking top of the map------------------------
					if(i == 0)
					{
						map[i][j].northTile = null;
					}
					else 
					{
						map[i][j].northTile = map[i-1][j];
					}
					
					//checking bottom of the map------------------
					if(i == map.length - 1)
					{
						map[i][j].southTile = null;
					}
					else
					{
						map[i][j].southTile = map[i+1][j];
					}
					
					//checking left bound of the map----------------
					if(j == 0)
					{
						map[i][j].westTile = null;
					}
					else
					{
						map[i][j].westTile = map[i][j-1];
					}
					
					//checking right bound of the map-----------------
					if(j == map[0].length - 1)
					{
						map[i][j].eastTile = null;
					}
					else
					{
						map[i][j].eastTile = map[i][j+1];
					}
				}
			}
			
			//#Define planet and contents
			var temp:Planet = new TestPlanet();//Construct new test planet and add Units and buildings owned by certain players
			planetList.push(temp); //add it to the planet list
			map[15][15].addPlanet(temp);
			var planetMap:Array = map[15][15].planet.getMap() //temp variable to hold the planets map (Pass by reference I think)
			
			planetMap[2][8].addUnit(new Infantry()); //temporary for testing
			planetMap[2][8].unit.initializeUnit(players[0]); //temporary for testing
			
			planetMap[3][8].addUnit(new Engineer()); //temporary for testing
			planetMap[3][8].unit.initializeUnit(players[0]); //temporary for testing
			
			planetMap[2][6].addUnit(new Infantry()); //temporary for testing
			planetMap[2][6].unit.initializeUnit(players[1]); //temporary for testing
			
			planetMap[4][1].addBuilding(new Factory()); //temp
			planetMap[4][1].building.initializeBuilding(players[0], planetMap[4][1]);
			
			planetMap[6][1].addBuilding(new City());
			planetMap[6][1].building.initializeBuilding(players[0], planetMap[6][1]);
			
			planetMap[7][1].addBuilding(new City());
			planetMap[7][1].building.initializeBuilding(players[0], planetMap[7][1]);
			
			planetMap[6][2].addBuilding(new City());
			planetMap[6][2].building.initializeBuilding(players[1], planetMap[6][2]);
			
			planetMap[8][1].addBuilding(new ResearchCenter());
			planetMap[8][1].building.initializeBuilding(players[0], planetMap[8][1]);
			//#End define planet contents
			
			//#Define 2nd planet and contents
			temp = new TestPlanet(); //Construct new test planet and add Units and buildings owned by certain players
			planetList.push(temp); //add it to the planet list
			map[15][20].addPlanet(temp);
			planetMap = null;
			planetMap = map[15][20].planet.getMap() //temp variable to hold the planets map (Pass by reference I think)
			
			planetMap[2][8].addUnit(new Infantry()); //temporary for testing
			planetMap[2][8].unit.initializeUnit(players[0]); //temporary for testing
			
			planetMap[3][8].addUnit(new Infantry()); //temporary for testing
			planetMap[3][8].unit.initializeUnit(players[0]); //temporary for testing
			
			planetMap[2][6].addUnit(new Infantry()); //temporary for testing
			planetMap[2][6].unit.initializeUnit(players[1]); //temporary for testing
			
			planetMap[4][1].addBuilding(new Factory()); //temp
			planetMap[4][1].building.initializeBuilding(players[0], planetMap[4][1]);
			
			planetMap[6][1].addBuilding(new City());
			planetMap[6][1].building.initializeBuilding(players[0], planetMap[6][1]);
			//#End define planet contents
			//Do the above for each planet added that you want to add units/buildings to.
			
			return map;
			
		}
	}
}