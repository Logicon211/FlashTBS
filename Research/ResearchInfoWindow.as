package Research
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ResearchInfoWindow extends MovieClip
	{
		private var researchName:TextField;
		private var researchCostRemaining:TextField;
		private var researchDescription:TextField;
		
		public function ResearchInfoWindow(txtFormat:TextFormat, item:ResearchItem)
		{
			super();
			
			researchName = new TextField(); //sets the text field with the embedded font passed in
			researchName.embedFonts = true;
			researchName.wordWrap = true;
			researchName.width = 200;
			researchName.height = 10;
			researchName.selectable = false;
			researchName.defaultTextFormat = txtFormat;
			researchName.x = 10;
			researchName.y = 10;
			researchName.textColor = 0xFFFFFF;
			addChild(researchName);
			
			researchCostRemaining = new TextField(); //sets the text field with the embedded font passed in
			researchCostRemaining.embedFonts = true;
			researchCostRemaining.wordWrap = true;
			researchCostRemaining.width = 200;
			researchCostRemaining.height = 10;
			researchCostRemaining.selectable = false;
			researchCostRemaining.defaultTextFormat = txtFormat;
			researchCostRemaining.x = 10;
			researchCostRemaining.y = 30;
			researchCostRemaining.textColor = 0xFFFFFF;
			addChild(researchCostRemaining);
			
			researchDescription = new TextField(); //sets the text field with the embedded font passed in
			researchDescription.embedFonts = true;
			researchDescription.wordWrap = true;
			researchDescription.width = 200;
			researchDescription.height = 60;
			researchDescription.selectable = false;
			researchDescription.defaultTextFormat = txtFormat;
			researchDescription.x = 10;
			researchDescription.y = 50;
			researchDescription.textColor = 0xFFFFFF;
			addChild(researchDescription);
			
			//sets the text for the window
			researchName.text = item.researchName;
			researchCostRemaining.text = "Time Remaining: " + item.getTimeLeft();
			researchDescription.text = item.description;
		}
		
	}
}