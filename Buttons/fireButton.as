package Buttons
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import main.Game;
	import main.PopUpMenu;
	import main.Utils;

	public class fireButton extends GameButton
	{
		public function fireButton()
		{
			super();
			infoText = "Attack using this building's weapons";
		}
		
		public override function performFunction(g:Game, s:Stage) //if it's the fire button (which comes from buildings who can attack)
		{
			g.selectedBuilding = g.selectedSecondTile.building; //set the selected building to the current one
			
			Utils.showAttackTiles(g.selectedSecondTile, g.selectedBuilding.maxRange, g.selectedBuilding.minRange, null, g.selectedBuilding); //show attack tiles for the building
			
			g.closePopUpMenu(); //close popup menu
			
			g.popUpMenu = new PopUpMenu();
			g.popUpMenu.list.push(new cancelButton()); //add a cancel button			
			
			g.popUpMenu.x = 1024; //Displays menu in bottom right corner.
			g.popUpMenu.y = s.stageHeight - g.popUpMenu.height;
			s.addChild(g.popUpMenu);
			g.popUpMenu.displayList();
			
			for(var l=0; l<g.popUpMenu.list.length; l++) //add listeners to the buttons in the menu
				
			{
				g.popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_UP, g.HandleButton, false, 0, true);
				g.popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OVER, g.mouseOverButton, false, 0, true);
				g.popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OUT, g.mouseOutButton, false, 0, true);
			}
			g.isMenuUp = true;
			
			g.waitingForAttack = true; //Now waiting for attack
			g.disableMapClicks = true; //cannot interact with map unit fireing is over;
		}
	}
}