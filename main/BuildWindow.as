package main
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BuildWindow extends MovieClip
	{
		var textInfo:TextField;
		var txtFont:OCRFont = new OCRFont();
		var txtFormat:TextFormat = new TextFormat(txtFont.fontName, 20); //regular font for most things
		
		public var buttonList:Array = new Array();
		
		public function BuildWindow()
		{
			super();
			textInfo = new TextField(); //sets the text field with the embedded font passed in
			textInfo.embedFonts = true;
			textInfo.wordWrap = true;
			textInfo.width = 300;
			textInfo.height = 100;
			textInfo.selectable = false;
			textInfo.defaultTextFormat = txtFormat;
			textInfo.x = 680;
			textInfo.y = 25;
			textInfo.textColor = 0xFFFFFF;
			addChild(textInfo);
		}
		
		public function updateText(text:String):void
		{
			textInfo.text = text;
		}
	}
}