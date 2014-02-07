package Buttons
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import main.Game;
	import main.InfoWindow;
	
	public class infoButton extends GameButton
	{
		public function infoButton()
		{
			super();
			infoText = "Display information about this tile"
		}
		
		public override function performFunction(g:Game, s:Stage) //info Button on any tile
		{
			if(g.infoWindow == null) //only display infoWindow if its not already up
			{
				trace("Info gets displayed");
				g.infoWindow = new InfoWindow(g.selectedSecondTile, g.txtFormat);
				g.infoWindow.closeButt.addEventListener(MouseEvent.MOUSE_DOWN, g.closeInfo, false, 0, true);
				g.infoWindow.x = 0;
				g.infoWindow.y = 0;
				stage.addChild(g.infoWindow);
				//selectedSecondTile = null; add this back in if problems come up
				
				//remove ability to interact with map until the info window is closed
				g.mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, g.dragMap);
				g.mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, g.scaleMap);
				g.disableMapClicks = true;
			}
		}
	}
}