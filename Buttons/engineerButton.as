package Buttons
{
	import Units.Engineer;

	public class engineerButton extends UnitButton
	{
		public function engineerButton()
		{
			super();
			unit = new Engineer();
		}
	}
}