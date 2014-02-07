package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import main.MapContainer;

	public class exitPlanetButton extends GameButton
	{
		public function exitPlanetButton()
		{
			super();
			infoText = "Exit planet view and return to space";
		}
		
		public override function performFunction(g:Game, s:Stage) //exits Planet view
		{
			s.removeChild(g.mapContainer) //remove the old map container
			g.mapContainer = new MapContainer() //initialize a new one to be populated
			
			g.map = g.selectedMap.map; //get the Game Map
			g.currentPlanet = null; //set current planet to the planet we selected
			
			g.initializeMap(g.map, g.selectedMap.getWidth(), g.selectedMap.getHeight()); //initialize the map
			g.clearSelectedData(); //clear the current selection of data while we load a new map
			g.closePopUpMenu()
		}
	}
}