package Buttons
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import main.Game;
	import main.Utils;
	

	public class doneButton extends GameButton
	{
		public function doneButton()
		{
			super();
			infoText = "Finish unit movement";
		}
		
		public override function performFunction(g:Game, s:Stage) //Done button after movement (FINISHING BUTTON)
		{
			g.selectedUnit.finishTurn(); //finishes the selected unit's turn
			
			Utils.revealFog(g.selectedSecondTile, g.selectedUnit.vision, g.turn); //recalculate vision after unit is done moving
			
			if(g.waitingForAttack) //if we were waiting on attack choice, remove the attack animations and the waiting on attack state
			{
				g.waitingForAttack = false;
				Utils.removeAttackTiles(g.selectedSecondTile, g.selectedUnit.maxRange, g.selectedUnit);
			}
			
			//set selected stuff to null so that we can continue commanding other units
			g.clearSelectedData();
			
			//reenable map interaction now that movement with unit is done
			g.mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, g.dragMap);
			g.mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, g.scaleMap);
			g.disableMapClicks = false;
			
			g.closePopUpMenu(); //closes pop up menu if its up
			
			g.closeInfoWindow(); //closes info window if its up
			
			g.finishButtonAvailable = false; //re-enable map control to the info screen since we are done moving the unit.
		}
	}
}