package Buttons
{
	import Units.Infantry;
	
	public class infantryButton extends UnitButton
	{
		public function infantryButton()
		{
			super();
			unit = new Infantry(); //add infantry unit to this button
		}
	}
}