package Buttons
{
	import Buildings.City;

	public class cityButton extends BuildingButton
	{
		public function cityButton()
		{
			super();
			building = new City();
		}
	}
}