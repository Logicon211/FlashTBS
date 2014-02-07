package Buttons
{
	import Buildings.ResearchCenter;
	
	public class researchCenterButton extends BuildingButton
	{
		public function researchCenterButton()
		{
			super();
			building = new ResearchCenter();
		}
	}
}