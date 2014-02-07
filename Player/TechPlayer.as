package Player
{
	import Races.Race;
	
	public class TechPlayer extends BasePlayer
	{
		public function TechPlayer(playerNum:int, startingCredits:int, startingResources:int)
		{
			super(playerNum, startingCredits, startingResources);
			race = TECH;
			
			researchList = new Array(/* number of research items here*/);
			
			//for each item added do researchList[-].initialize(this);
		}
	}
}