package main
{
	import Planets.Planet;
	
	import Player.BasePlayer;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StatusWindow extends MovieClip
	{
		public var playerInfo:TextField;
		public var creditInfo:TextField; //credits of player
		public var resourceInfo:TextField; //resources of player
		
		//status window is the window which resides in the top or bottom left that indicates available resources
		public function StatusWindow(txtFormat:TextFormat)
		{
			super();
			playerInfo = new TextField(); //sets the text field with the embedded font passed in
			playerInfo.embedFonts = true;
			playerInfo.wordWrap = true;
			playerInfo.width = 120;
			playerInfo.height = 20;
			playerInfo.selectable = false;
			playerInfo.defaultTextFormat = txtFormat;
			playerInfo.x = 10;
			playerInfo.y = 10;
			playerInfo.textColor = 0xFFFFFF;
			addChild(playerInfo);
			
			creditInfo = new TextField(); //sets the text field with the embedded font passed in
			creditInfo.embedFonts = true;
			creditInfo.wordWrap = true;
			creditInfo.width = 120;
			creditInfo.height = 20;
			creditInfo.selectable = false;
			creditInfo.defaultTextFormat = txtFormat;
			creditInfo.x = 10;
			creditInfo.y = 25;
			creditInfo.textColor = 0xFFFFFF;
			addChild(creditInfo);
			
			resourceInfo = new TextField(); //sets the text field with the embedded font passed in
			resourceInfo.embedFonts = true;
			resourceInfo.wordWrap = true;
			resourceInfo.width = 120;
			resourceInfo.height = 20;
			resourceInfo.selectable = false;
			resourceInfo.defaultTextFormat = txtFormat;
			resourceInfo.x = 10;
			resourceInfo.y = 40;
			resourceInfo.textColor = 0xFFFFFF;
			addChild(resourceInfo);
		}
		
		//call this function to update the information on screen
		public function updateInfo(player:BasePlayer, planet:Planet = null)
		{
			playerInfo.text = "Player " + player.playerNumber; //will probably change to player name later
			creditInfo.text = "Credits: " + player.credits;
			if(planet != null) // if on a planet
			{
				resourceInfo.text ="Resources: " + planet.getPlayerResources(player.playerNumber);
			}
			else //if in space
			{
				resourceInfo.text =""; //no planet, in space, no resources.
			}
		}
	}
}