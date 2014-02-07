package Map
{
	import Units.Unit;
	import MovementTypes.*;
	
	public class ForestTile extends MapTile
	{
		public function ForestTile()
		{
			super();
			information = "This is forest tile. extra information will be displayed here";
			defenseValue = 2;
			tileName = "Forest";
			blocksVision = true; //forests block vision unless a unit is right beside it.
			canBuild = false; //cannot build buildings on a forest tile.
		}
		
		override public function getCost(unit:Unit):int
		{
			//THIS MUST BE PRESENT IN EVERY TILE
			if(this.hasUnit() && this.unit.player != unit.player && this.isVisible) //if this tile currently contains a unit which is not owned by the current player, AND it is currently visible, then the terrain is impassible (cost 9999)
			{
				return 9999;
			}
			
			if(this.hasBuilding() && this.building.player != unit.player && !this.building.allowsEnemyMovement) //if this tile contains a building not owned by the player and the building is impassible to enemies, it is impassible (cost 9999)
			{
				return 9999;
			}
			
			if(unit.moveType is Foot)
			{
				return 2; //probably not going to be 2 for foot movement, just for testing
			}
			else
			{
				return 1;
			}
		}
	}
}