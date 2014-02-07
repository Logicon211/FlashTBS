package Player
{
	import Races.Race;
	
	public class InfectedPlayer extends BasePlayer
	{
		public function InfectedPlayer(playerNum:int, startingCredits:int, startingResources:int)
		{
			super(playerNum, startingCredits, startingResources);
			race = INFECTED;
			
			researchList = new Array(/* number of research items here*/);
			
			//for each item added do researchList[-].initialize(this);
		}
	}
}