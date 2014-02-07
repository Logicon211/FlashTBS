package Buttons
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import main.Game;
	import main.Utils;
	
	public class cancelButton extends GameButton
	{
		public function cancelButton()
		{
			super();
			infoText = "Cancel current action";
		}
		
		public override function performFunction(g:Game, s:Stage) //cancel current move and put unit back to original place (FINISHING BUTTON)
		{
			if(g.selectedBuilding == null) //if we're not working with a building (IE a unit, do this)
			{
				g.selectedSecondTile.removeUnit();
				g.selectedTile.addUnit(g.selectedUnit);
				
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
				
			else //if we were waiting for a building, do this, reenable everything
			{
				Utils.removeAttackTiles(g.selectedSecondTile, g.selectedBuilding.maxRange, null, g.selectedBuilding);
				
				g.waitingForAttack = false;
				g.closePopUpMenu();
				g.clearSelectedData();
				g.disableMapClicks = false;
			}
		}
	}
}