package main
{
	import Map.MapTile;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class QuickInfoWindow extends MovieClip
	{
		private var tileName:TextField;
		private var tileDef:TextField;
		private var tileHealth:TextField; //if its a building
		
		private var unitName:TextField; //Unit name if any
		private var unitHealth:TextField;
		
		public function QuickInfoWindow(txtFormat:TextFormat)
		{
			super();
			tileName = new TextField(); //sets the text field with the embedded font passed in
			tileName.embedFonts = true;
			tileName.wordWrap = true;
			tileName.width = 100;
			tileName.height = 10;
			tileName.selectable = false;
			tileName.defaultTextFormat = txtFormat;
			tileName.x = 10;
			tileName.y = -130;
			tileName.textColor = 0xFFFFFF;
			addChild(tileName);
			
			tileDef = new TextField(); //sets the text field with the embedded font passed in
			tileDef.embedFonts = true;
			tileDef.wordWrap = true;
			tileDef.width = 100;
			tileDef.height = 10;
			tileDef.selectable = false;
			tileDef.defaultTextFormat = txtFormat;
			tileDef.x = 10;
			tileDef.y = -110;
			tileDef.textColor = 0xFFFFFF;
			addChild(tileDef);
			
			tileHealth = new TextField(); //sets the text field with the embedded font passed in
			tileHealth.embedFonts = true;
			tileHealth.wordWrap = true;
			tileHealth.width = 100;
			tileHealth.height = 10;
			tileHealth.selectable = false;
			tileHealth.defaultTextFormat = txtFormat;
			tileHealth.x = 10;
			tileHealth.y = -90;
			tileHealth.textColor = 0xFFFFFF;
			addChild(tileHealth);
			
			unitName = new TextField(); //sets the text field with the embedded font passed in
			unitName.embedFonts = true;
			unitName.wordWrap = true;
			unitName.width = 100;
			unitName.height = 10;
			unitName.selectable = false;
			unitName.defaultTextFormat = txtFormat;
			unitName.x = 10;
			unitName.y = -60;
			unitName.textColor = 0xFFFFFF;
			addChild(unitName);
			
			unitHealth = new TextField(); //sets the text field with the embedded font passed in
			unitHealth.embedFonts = true;
			unitHealth.wordWrap = true;
			unitHealth.width = 100;
			unitHealth.height = 10;
			unitHealth.selectable = false;
			unitHealth.defaultTextFormat = txtFormat;
			unitHealth.x = 10;
			unitHealth.y = -40;
			unitHealth.textColor = 0xFFFFFF;
			addChild(unitHealth);
		}
		
		public function updateInfo(tile:MapTile)
		{
			if(tile.hasBuilding() && tile.isVisible)
			{
				tileName.text = tile.building.buildingName;
				tileDef.text = "Def: " + tile.building.defenseValue;
				tileHealth.text = "HP: " + tile.building.health;
			}
			else if(tile.hasPlanet())
			{
				tileName.text = tile.planet.getName();
				tileDef.text = "Def: " + tile.defenseValue;
			}
			else
			{
				tileName.text = tile.tileName;
				tileDef.text = "Def: " + tile.defenseValue;
				tileHealth.text = "";
			}
			
			if(tile.hasUnit() && tile.isVisible)
			{
				unitName.text = tile.unit.unitName;
				unitHealth.text ="HP: " + tile.unit.health;
			}
			else
			{
				unitName.text = "";
				unitHealth.text = "";
			}
		}
	}
}