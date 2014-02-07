package Research
{
	import Buildings.Factory;
	
	public class HumanBuildingUpgrade extends ResearchItem
	{
		public function HumanBuildingUpgrade()
		{
			super();
			
			xCord = 150;
			yCord = 200;
			
			timeCost = 10;
			timeLeft = timeCost;
			
			researchName = "Building Range Upgrade";
			description = "Increases Factory range to 5";
			
			prereqList.push(new HumanInfantryUpgrade()); //add the human infantry upgrade prereq, Just a test for now
		}
		
		//when completed it will upgrade all current infantry.
		public override function onCompleted():void
		{
			trace("Building upgrade complete*****************************************");
			for(var i=0; i < player.unitList.length; i++)
			{
				if(player.buildingList[i] is Factory)
				{
					player.buildingList[i].maxRange = 5; //TEST type. will definitely not be this after
				}
			}
			
			selected = false; //it is finished so it is no longer selected
			player.activeResearch = null; //This is ocmpleted so the ucrrent actie research is nothing now.
		}
	}
}