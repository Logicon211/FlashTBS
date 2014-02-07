package main
{
	import Map.MapTile;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Buttons.closeButton;
	
	public class InfoWindow extends MovieClip
	{
		public var closeButt:closeButton = new closeButton();
		public var tileInfo:TextField;
		public var unitInfo:TextField;
		public function InfoWindow(tile:MapTile, txtFormat:TextFormat)
		{
			super();
			tileInfo = new TextField(); //sets the text field with the embedded font passed in
			tileInfo.embedFonts = true;
			tileInfo.wordWrap = true;
			tileInfo.width = 400;
			tileInfo.height = 350;
			tileInfo.selectable = false;
			tileInfo.defaultTextFormat = txtFormat;
			tileInfo.x = 25;
			tileInfo.y = 25;
			tileInfo.textColor = 0xFFFFFF;
			if(!tile.hasBuilding()) //if there's no building on tile, display tile info
			{
				tileInfo.text = tile.information; //tile will store info string later and display it here. No working at the moment
			}
			else //if there is a building, display building info
			{
				tileInfo.text = tile.building.information; //tile will store info string later and display it here. No working at the moment
			}
			addChild(tileInfo);
			
			if(tile.hasUnit())
			{
				unitInfo = new TextField();
				unitInfo.embedFonts = true;
				unitInfo.wordWrap = true;
				unitInfo.width = 400;
				unitInfo.height = 350;
				unitInfo.selectable = false;
				unitInfo.defaultTextFormat = txtFormat;
				unitInfo.x = 25;
				unitInfo.y = 400;
				unitInfo.textColor = 0xFFFFFF;
				unitInfo.text = tile.unit.information;
				addChild(unitInfo);
			}
			closeButt.x = this.width - 150;
			closeButt.y = this.height - 50;
			addChild(closeButt); //adds close button to screen
		}
	}
}