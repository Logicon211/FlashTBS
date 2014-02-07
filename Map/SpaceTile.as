package Map
{
	import Units.Unit;
	import MovementTypes.*;
	
	public class SpaceTile extends MapTile
	{
		public function SpaceTile()
		{
			super();
			information = "This is a Space tile extra information will be displayed here";
			defenseValue = 0;
			tileName = "Space";
		}
		
		override public function getCost(unit:Unit):int
		{
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
				return 9999; //Don't have space movement yet so Foot is the only thing defined
			}
			else
			{
				return 1;
			}
		}
	}
}