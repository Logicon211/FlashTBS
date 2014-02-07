package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import main.MapContainer;

	public class gotoPlanetButton extends GameButton
	{
		public function gotoPlanetButton()
		{
			super();
			infoText = "Enter the planet to view the map and give commands";
		}
		
		public override function performFunction(g:Game, s:Stage) //Enters planet view
		{
			s.removeChild(g.mapContainer) //remove the old map container
			g.mapContainer = new MapContainer //initialize a new one to be populated
			
			g.map = g.selectedSecondTile.planet.getMap(); //get the planet map
			g.currentPlanet = g.selectedSecondTile.planet; //set current planet to the planet we selected
			
			g.initializeMap(g.map, g.currentPlanet.getWidth(), g.currentPlanet.getHeight()); //initialize the map
			g.clearSelectedData(); //clear the current selection of data while we load a new map
			g.closePopUpMenu()
		}
	}
}