package main
{
	import Buttons.GameButton;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ButtonInfoWindow extends MovieClip
	{
		
		private var buttonInfo:TextField;
		
		public function ButtonInfoWindow(txtFormat:TextFormat)
		{
			super();
			buttonInfo = new TextField(); //sets the text field with the embedded font passed in
			buttonInfo.embedFonts = true;
			buttonInfo.wordWrap = true;
			buttonInfo.width = 500;
			buttonInfo.height = 70;
			buttonInfo.selectable = false;
			buttonInfo.defaultTextFormat = txtFormat;
			buttonInfo.x = 10;
			buttonInfo.y = 10;
			buttonInfo.textColor = 0xFFFFFF;
			addChild(buttonInfo);
		}
		
		public function updateInfo(button:GameButton):void
		{
			buttonInfo.text = button.getInfo();
		}
		
		public function clearInfo():void
		{
			buttonInfo.text = "";
		}
	}
}