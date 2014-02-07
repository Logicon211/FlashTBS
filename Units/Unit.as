package Units  
{
	import ArmorTypes.*;
	
	import Buildings.Building;
	
	import CustomEvents.*;
	
	import Map.MapTile;
	
	import MovementTypes.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import main.BuildWindow;
	import main.ImpactFont;
	import Player.BasePlayer;
	
	public class Unit extends MovieClip
	{
		public var movement:int = 0;
		public var moveType:MoveType;
		
		public var information:String = "";
		public var unitName:String = ""; //unit name
		
		public var health:int = 10; //current health
		public var maxHealth:int = 10; //maximum health
		public var maxRange:int = 0;// units attack range
		public var minRange:int = -1// unit minimum range, -1 so that it can still target the tile its on
		public var vision:int = 0; //units vision range
		public var armor:Armor;
		public var defense:Number = 0.0;
		public var isIndirect:Boolean = false; //to check whether this unit is an indirect fire unit or not.
		
		//types of units this unit can attack. Add more if more unit types become available
		protected var canAttackGround:Boolean = false;
		protected var canAttackPlane:Boolean = false;
		protected var canAttackCopter:Boolean = false;
		protected var canAttackSea:Boolean = false;
		protected var canAttackSpace:Boolean = false;
		
		public var creditCost:int = 0;
		public var resourceCost:int = 0; //costs to make the unit
		
		public var player:BasePlayer; //Which player owns this unit
		public var location:MapTile; //where the unit currently is. May need to use as object later (because units might be inside other units or buildings)
		
		public var hasDoneTurn:Boolean = false; //variable to determine if the unit has already done its turn
		
		public var txtFont:ImpactFont = new ImpactFont;
		public var healthFormat:TextFormat = new TextFormat(txtFont.fontName,13); //font for the health number displayed at the bottom right
		public var unitHealth:TextField;
		
		public var buildWindow:BuildWindow; //build window for building units
		
		//used in determining the direction the unit animation should display
		public var lastX:Number;
		public var lastY:Number;
		
		public function Unit()
		{
			super();
			
			//set up the unit health display
			unitHealth = new TextField();
			unitHealth.embedFonts = true;
			unitHealth.defaultTextFormat = healthFormat;
			unitHealth.x = 35;
			unitHealth.y = 35;
			unitHealth.textColor = 0xEE0000; //sets color to ....
			unitHealth.selectable = false;
			addChild(unitHealth);
			
			updateHealth(); //updates the health to display it on screen
			
			//add listeners to attack and be attacked
			this.addEventListener(FireEvent.FIRE, unitFired, false, 0, true);
			this.addEventListener(DefendEvent.DEFEND, unitHit, false, 0, true);
		}
		public function initializeUnit(playerOwned:BasePlayer):void //initializes the unit to the player that owns it
		{
			player = playerOwned;
			player.unitList.push(this); //add this unit to the players list of units. To remove units, try searching for it and doing array.splice
			
			//determines starting color using player Number
			if(player.playerNumber == 1)
			{
				gotoAndPlay("redIdle");
			}
			else if(player.playerNumber == 2)
			{
				gotoAndPlay("blueIdle");
			}
			//TODO: Add more teams and colors
			
			//after a units player has been initialized, it retrieves possible upgrades that play might have for the unit
			getUpgrades();
		}
		
		//to be overwritten in units that have possible upgrades. the player class is not initialized so a unit can look through the research for it
		public function getUpgrades():void
		{
			
		}
		
		public function DoneTurn():Boolean //returns if the unit has done its turn or not
		{
			return hasDoneTurn;
		}
		
		public function finishTurn():void //finishes the units turn and sets it to the appropriate finish animation
		{
			hasDoneTurn = true;
			
			//sets the correct done idle animation depending on player number.
			if(player.playerNumber == 1)
			{
				gotoAndPlay("redDoneIdle");
			}
			else if(player.playerNumber == 2)
			{
				gotoAndPlay("blueDoneIdle");
			}
			//more colors/teams to come
		}
		
		public function renewTurn():void //renews units turn and sets the appropriate animation (IE not shaded)
		{
			hasDoneTurn = false;
			
			//determines color using player Number
			if(player.playerNumber == 1)
			{
				gotoAndPlay("redIdle");
			}
			else if(player.playerNumber == 2)
			{
				gotoAndPlay("blueIdle");
			}
			//more colors/teams to come
		}
		
		//this updates the units current health display
		public function updateHealth():void
		{
			unitHealth.text = health + ""; //displays current health
		}
		
		public function getAbilities(enemyWithinRange:Boolean, tile:MapTile /*may add other conditions later*/):Array
		{
			var abilities:Array = new Array(); //just return super() if the unit has no abilities
			
			return abilities;
		}
		
		public function canAttack(unit:Unit):Boolean
		{
			//return the canAttack variables depending on unit type
			if(unit is GroundUnit)
			{
				return canAttackGround;
			}
			else if(unit is PlaneUnit)
			{
				return canAttackPlane;
			}
			else if(unit is CopterUnit)
			{
				return canAttackCopter;
			}
			else if(unit is SeaUnit)
			{
				return canAttackSea;
			}
			else if(unit is SpaceUnit)
			{
				return canAttackSpace;
			}
			else //shouldnt happen, but its needed for the compiler
			{
				return false;
			}
		}
		
		//just a simple ground attack check so that we can mark buildings for attack
		public function canAttackBuildings():Boolean
		{
			return canAttackGround;
		}
		
		//To be overwritten by other units, used to calculate damage done to another unit, requires the Unit targeted, and the tile it is on. default enemy unit to null because you may be able to attack the building
		public function calculateDamage(enemyMapTile:MapTile):int
		{
			//General formula will be:
			// ((Base Damage vs Armor type / ((Defense of tile x2 / 10) + 1)) x health/maxhealth) - Enemy Defense value/(Enemy Unit Health / enemyMaxHealth)  ---- All rounded to the nearest, 1.5 goes down(?)
			return 0; //to be overwritten
		}
		
		//Function to take damage from another unit, if it reaches 0, the unit is destroyed and deleted from the maptile it resides
		public function takeDamage(damage:int):void
		{
			health = health - damage;
			updateHealth();
			if(health <= 0)
			{
				player.removeUnit(this); //remove this unit from the player list
				location.removeUnit(); //calls the containing maptile to delete it.
			}
		}
		
		public function initializeBuildWindow():BuildWindow
		{
			trace("Error: unit attempting to build without the ability to");
			return buildWindow;
		}
		
		public function clearBuildWindow():void //this function clears the build window
		{
			buildWindow = null;
		}
		
		//event when a unit attacks
		public function unitFired(e:FireEvent):void
		{
			//really just a test, this will be defaulted to nothing. We will add to each unit what happens after they fire and play fire animation (usually disperse ammo)
			
			if(e.mapTileToHit.hasUnit()) //if the maptile has a unit, the target is it
			{
				var targetUnit:Unit = e.mapTileToHit.unit;
				trace(this + "Fired on " + targetUnit);
			}
			else if(e.mapTileToHit.hasBuilding()) //else if it has a building we fire on that
			{
				var targetBuilding:Building = e.mapTileToHit.building;
				trace(this + "Fired on " + targetBuilding);
			}
			else
			{
				trace("Error: unit fired on tile with no target"); //shouldnt happen
			}
		}
		
		//event when a unit gets attacked
		public function unitHit(e:DefendEvent):void
		{
			//again, more for testing. Wil use this for special abilities for units when they take a hit
			trace(this + " was hit");
		}
		
		//adds the listener to check each frame for which direction the unit is moving in
		public function addMovementEventListener():void
		{
			//sets the last coordinates to its current position
			lastX = this.x;
			lastY = this.y;
			this.addEventListener(Event.ENTER_FRAME, determineMoveAnimation, false, 0, true);
		}
		
		//removes that listener
		public function removeMovementEventListener():void
		{
			this.removeEventListener(Event.ENTER_FRAME, determineMoveAnimation);
			
			//now we check for player color so that we can make sure the animation is the right color for idle animations
			if(player.playerNumber == 1) //red
			{
				gotoAndPlay("redIdle");
			}
			else if(player.playerNumber == 2) //blue
			{
				gotoAndPlay("blueIdle");
			}
			//TODO: Add more player colors ..
		}
		
		//Activated when a unit is tweened so that we can determine which animation direction to show
		public function determineMoveAnimation(e:Event):void
		{
			if(lastY > this.y) //Unit movement Up
			{
				//now we check for player color so that we can make sure the animation is the right color
				if(player.playerNumber == 1) //red
				{
					gotoAndPlay("redMoveUp");
				}
				else if(player.playerNumber == 2) //blue
				{
					gotoAndPlay("blueMoveUp");
				}
				//TODO: Add more player colors ..
			}
			else if (lastX < this.x) //Unit movement Right
			{
				//now we check for player color so that we can make sure the animation is the right color
				if(player.playerNumber == 1) //red
				{
					gotoAndPlay("redMoveRight");
				}
				else if(player.playerNumber == 2) //blue
				{
					gotoAndPlay("blueMoveRight");
				}
				//TODO: Add more player colors ..
				
			}
			else if (lastY < this.y) //Unit movement Down
			{
				//now we check for player color so that we can make sure the animation is the right color
				if(player.playerNumber == 1) //red
				{
					gotoAndPlay("redMoveDown");
				}
				else if(player.playerNumber == 2) //blue
				{
					gotoAndPlay("blueMoveDown");
				}
				//TODO: Add more player colors ..
			}
			else if(lastX > this.x) //Unit movement Left
			{
				//now we check for player color so that we can make sure the animation is the right color
				if(player.playerNumber == 1) //red
				{
					gotoAndPlay("redMoveLeft");
				}
				else if(player.playerNumber == 2) //blue
				{
					gotoAndPlay("blueMoveLeft");
				}
				//TODO: Add more player colors ..
			}
			
			//setting the last values to the current values for the next check
			lastX = this.x;
			lastY = this.y;
			
		}
	}
}