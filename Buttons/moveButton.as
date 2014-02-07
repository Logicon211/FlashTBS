package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import main.Utils;
	
	public class moveButton extends GameButton
	{
		public function moveButton()
		{
			super();
			infoText = "Move unit";
		}
		
		public override function performFunction(g:Game, s:Stage) //move button for units when they are on the same tile as a building when you select it
		{
			//run method to show movement tiles
			Utils.showMoveTiles(g.selectedTile, g.selectedUnit.movement, g.selectedUnit);
			g.waitingForMoveSelection = true;
			g.shortestPath.unshift(g.selectedTile); //add the current tile to selectedMoveTile, for keyboard movement
			
			g.closePopUpMenu(); //Closes popup menu if its up
			g.disableMapClicks = false; //re-enable map clicks to be able to move units
		}
	}
}