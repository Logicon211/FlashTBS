package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import flash.events.MouseEvent;

	public class constructButton extends GameButton
	{
		public function constructButton()
		{
			super();
			infoText = "Construct a building";
		}
		
		public override function performFunction(g:Game, s:Stage) //if it's the construct button (The one where units build buildings)(FINISH BUTTON IF THE UNIT DOESN'T CANCEL THE CONSTRUCTION)
		{
			g.buildWindow = g.selectedUnit.initializeBuildWindow();
			
			if(g.buildWindow != null) //null checking first
			{
				//closePopUpMenu(); //closes pop up menu if its up
				g.hidePopUpMenu();
				
				g.buildWindow = g.selectedUnit.initializeBuildWindow();//take the build window from the unit selected
				
				for(var i:int = 0; i<g.buildWindow.buttonList.length; i++)
				{
					g.buildWindow.buttonList[i].addEventListener(MouseEvent.MOUSE_UP, g.buildEntity, false, 0, true);
				}
				var closeBut:closeButton = new closeButton();
				closeBut.x = 370;
				closeBut.y = 740;
				closeBut.addEventListener(MouseEvent.MOUSE_UP, g.closeBuildWindow, false, 0, true); //add a close button that closes the window
				g.buildWindow.addChild(closeBut);
				
				stage.addChild(g.buildWindow);
				
				//remove ability to interact with map until the Build window is closed
				g.mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, g.dragMap);
				g.mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, g.scaleMap);
				g.disableMapClicks = true;
			}
		}
	}
}