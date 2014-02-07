package Buttons
{
	import Buildings.Factory;

	public class factoryButton extends BuildingButton
	{
		public function factoryButton()
		{
			super();
			building = new Factory();
		}
	}
}