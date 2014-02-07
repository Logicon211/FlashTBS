package Player
{
	import Research.HumanInfantryUpgrade;
	import Research.HumanBuildingUpgrade;
	
	public class HumanPlayer extends BasePlayer
	{
		public function HumanPlayer(playerNum:int, startingCredits:int, startingResources:int)
		{
			super(playerNum, startingCredits, startingResources);
			race = HUMAN;
			
			researchList = new Array( 1 /* number of research items here*/);
			
			researchList[0] = new HumanInfantryUpgrade();
			researchList[0].initialize(this);
			
			researchList[1] = new HumanBuildingUpgrade();
			researchList[1].initialize(this);
			//for each item added do researchList[-].initialize(this);
		}
	}
}