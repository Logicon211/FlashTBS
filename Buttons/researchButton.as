package Buttons
{
	import flash.display.Stage;
	
	import main.Game;
	import flash.events.MouseEvent;
	import Research.ResearchWindow

	public class researchButton extends GameButton
	{
		public function researchButton()
		{
			super();
			infoText = "Research new technologies to unlock or improve units and buildings.";
		}
		
		public override function performFunction(g:Game, s:Stage) //Research button brings up the research menu.
		{
			g.closePopUpMenu(); //closes pop up menu if its up
			
			g.researchWindow = new ResearchWindow(g.statusFormat);
			g.researchWindow.x = 0;
			g.researchWindow.y = 0;
			g.researchWindow.height = s.stageHeight
			g.researchWindow.width = s.stageWidth;
			s.addChild(g.researchWindow); //add it to the stage
			
			//Add the research list from the current player to the research window
			g.researchWindow.addResearchList(g.turn.researchList);
			
			var closeBut:closeButton = new closeButton();
			closeBut.x = g.researchWindow.width - 150;
			closeBut.y = g.researchWindow.height - 150;
			closeBut.addEventListener(MouseEvent.MOUSE_UP, g.closeResearchWindow, false, 0, true); //add a close button that closes the window
			
			g.researchWindow.addChild(closeBut); //add a close button to the research window
			
			//remove ability to interact with map until the research window is closed
			g.mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, g.dragMap);
			g.mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, g.scaleMap);
			g.disableMapClicks = true;
		}
	}
}