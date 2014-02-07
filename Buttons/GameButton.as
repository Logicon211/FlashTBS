package Buttons
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import main.Game;
	
	public class GameButton extends MovieClip
	{
		protected var infoText:String = ""; //Info to display when player hovers over a button
		
		public function GameButton()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER, highlight);
			this.addEventListener(MouseEvent.MOUSE_OUT, stopHighlight);
		}
		
		public function highlight(e:MouseEvent)
		{
			gotoAndStop("mouseOver");
		}
		
		public function stopHighlight(e:MouseEvent)
		{
			gotoAndStop(0);
		}
		
		public function getInfo():String
		{
			return infoText;
		}
		
		public function performFunction(g:Game, s:Stage) //Generic function that will be overridden by all other buttons. Dictates what they will do ingame
		{
			//override this
		}
	}
}