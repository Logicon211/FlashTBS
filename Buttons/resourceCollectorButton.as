package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import Buildings.ResourceCollector;

	public class resourceCollectorButton extends GameButton
	{
		public function resourceCollectorButton()
		{
			super();
			infoText = "Construct a resource Collector at this location";
		}
		
		public override function performFunction(g:Game, s:Stage)  //resource collector button constructs a resource collector at this current point
		{
			g.selectedSecondTile.addBuilding(new ResourceCollector()); //build resource collector here.
			g.selectedSecondTile.building.initializeBuilding(g.turn, g.selectedSecondTile); //Initialize it to the current players turn and location
			
			g.selectedUnit.finishTurn(); //builder finishes turn
			g.closePopUpMenu();
			
			g.disableMapClicks = false; //re-enable map clicks to be able to move units
		}
	}
}