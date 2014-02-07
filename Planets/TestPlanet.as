package Planets
{
	import Map.*;
	import Units.*;
	import Buildings.*;
	
	public class TestPlanet extends Planet
	{
		public function TestPlanet()
		{
			super();
			planetName = "Test Planet";
			description = "This is a test planet used to test what I'm adding into the game";
			resourcePoints = 1; //1 resource point, adding more to test later
			
			mapWidth = 32;
			mapHeight = 32;
			
			trace("Building Test Planet...")
			map = new Array();
			
			for(var k:Number = 0;k < mapHeight;k++) { //declaring 2D array, limits of k is the height of the map
				map[k] = new Array();
			}
			
			//Setting up a temp all grass map and some forest for tests, this will defenitely change
			for(var i:Number = 0;i < mapHeight;i++){ //Heigth
				for(var j:Number = 0;j < mapWidth;j++) { //Width
					
					// alternating grass/forest tile for testing purposes
					if(i%2 == 0)
					{
						map[i][j] = new GrassTile();
						
					}
					else
					{
						map[i][j] = new ForestTile();
					}
					
					map[i][j].xCord = j;
					map[i][j].yCord = i;
					map[i][j].x = (map[i][j].width *(j));
					map[i][j].y = (map[i][j].height *(i));
				}
			}
			
			map[4][4] = null;
			map[4][4] = new ResourceTile(); //testing out the one resource Tile
			map[4][4].xCord = 4;
			map[4][4].yCord = 4;
			map[4][4].x = (map[4][4].width *(4));
			map[4][4].y = (map[4][4].height *(4));
			
			
			//Setting up connections to each maptile
			for(i=0; i<map.length; i++){
				for(j=0; j<map[0].length; j++){
					
					map[i][j].ownedPlanet = this; //assign each maptile this planet as it's owner
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
		}
	}
}