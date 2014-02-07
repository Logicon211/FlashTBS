package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import flash.events.MouseEvent;

	public class buildButton extends GameButton
	{
		public function buildButton()
		{
			super();
			infoText = "Build a unit from this building";
		}
		
		public override function performFunction(g:Game, s:Stage) //Build button to bring up a build menu. When finished the method that closes the build menu should set finishButtonAvailable to false
		{
			g.closePopUpMenu(); //closes pop up menu if its up
			
			g.buildWindow = g.selectedSecondTile.building.initializeBuildWindow(); //initialize build window and pass it to the main game
			
			for(var i:int = 0; i<g.buildWindow.buttonList.length; i++)
			{
				g.buildWindow.buttonList[i].addEventListener(MouseEvent.MOUSE_UP, g.buildEntity, false, 0, true);
			}
			var closeBut:closeButton = new closeButton();
			closeBut.x = 370;
			closeBut.y = 740;
			closeBut.addEventListener(MouseEvent.MOUSE_UP, g.closeBuildWindow, false, 0, true); //add a close button that closes the window
			g.buildWindow.addChild(closeBut);
			
			s.addChild(g.buildWindow);
			
			//remove ability to interact with map until the Build window is closed
			g.mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, g.dragMap);
			g.mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, g.scaleMap);
			g.disableMapClicks = true;
		}
	}
}