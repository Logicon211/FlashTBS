package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import flash.events.MouseEvent;
	import main.Utils;

	public class endButton extends GameButton
	{
		public function endButton()
		{
			super();
			infoText = "End turn";
		}
		
		public override function performFunction(g:Game, s:Stage) //End turn button passes turn to the next player
		{
			g.clearSelectedData(); //sets everything selected to null incase we have any left over
			
			g.turn.renewTurn(); //renews the turn of all units which are currently owned by the player, as the turn is changing
			
			//player number is always 1 more than the position of the array
			if(g.turn.playerNumber == g.players.length) //if the player number equals the array length, we go back to the 0 index (IE player 1)
			{
				g.turn = g.players[0]; //player 1
			}
			else //else we advance the turn to the next player
			{
				g.turn = g.players[g.turn.playerNumber]; 
			}
			
			g.turn.giveIncome(g.selectedMap.planetList); //give income to the player whos turn it is, passes planet list to calculate resources as well
			
			g.statusWindow.updateInfo(g.turn, g.currentPlanet); //updates Status window doe new turn
			
			//if pop up menu or info window is up, close them and re-enable map control
			g.closePopUpMenu();
			if(g.infoWindow != null)
			{
				//re-enable map control
				g.mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, g.dragMap);
				g.mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, g.scaleMap);
				g.disableMapClicks = false;
				g.closeInfoWindow();
			}
			
			Utils.calculateVision(g.map, g.turn); //recalculate vision for the new players turn
			trace("Player " + g.turn.playerNumber + "'s Turn");
		}
	}
}