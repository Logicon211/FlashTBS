package Research
{
	import ArmorTypes.building_medium;
	
	import Units.Infantry;

	public class HumanInfantryUpgrade extends ResearchItem
	{
		public function HumanInfantryUpgrade()
		{
			super();
			
			xCord = 50;
			yCord = 50;
			
			timeCost = 10;
			timeLeft = timeCost;
			
			researchName = "Infantry Armor Upgrade";
			description = "Upgrades infantry armor to building armor";
		}
		
		//when completed it will upgrade all current infantry.
		public override function onCompleted():void
		{
			trace("Infantry upgrade complete*****************************************");
			for(var i=0; i < player.unitList.length; i++)
			{
				if(player.unitList[i] is Infantry)
				{
					player.unitList[i].armor = new building_medium(); //TEST type. will definitely not be this after
				}
			}
			
			selected = false; //it is finished so it is no longer selected
			player.activeResearch = null; //This is ocmpleted so the ucrrent actie research is nothing now.
		}
	}
}