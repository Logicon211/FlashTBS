package Research
{
	import Player.BasePlayer;
	
	import flash.display.MovieClip;
	
	public class ResearchItem extends MovieClip
	{
		protected var player:BasePlayer
		
		protected var timeCost:int;
		protected var timeLeft:int;
		
		public var xCord:int;
		public var yCord:int; //Variables to determine where on the research map this object is
		
		protected var completed:Boolean = false; //boolean variable to tell if this item has been finished already
		protected var selected:Boolean = false;
		
		public var prereqList:Array = new Array(); //list of prerequisite research that needs to be done first
		
		public var researchName:String = ""; //Research name
		public var description:String = ""; //Description of the research
		
		public function ResearchItem()
		{
			super();
		}
		
		//used to initialize to a race and essentially a player list. ot n the constructor because the game will periodically generate a research object for comparison
		public function initialize(playerOwned:BasePlayer):void
		{
			player = playerOwned;
		}
		
		public function getTimeCost():int
		{
			return timeCost;
		}
		
		public function getTimeLeft():int
		{
			return timeLeft;
		}
		
		public function getSelected():Boolean
		{
			return selected;
		}
		
		//takes the work amount and takes it away from the time remaining
		public function workTime(amount:int):void
		{
			timeLeft = timeLeft - amount;
			
			if(timeLeft <= 0) //If we've gone through all of the time left, its completed so call the on complete
			{
				timeLeft = 0;
				completed = true; // set completed to true
				onCompleted();
			}
		}
		
		public function isComplete():Boolean
		{
			return completed;
		}
		
		//this function checks to see if this research object is available for research
		public function isAvailable():Boolean
		{
			var ret:Boolean = false;
			
			if(prereqList.length <= 0) //if there's no prereqs
			{
				ret = true;
			}
			else
			{
				for(var i:int=0; i < prereqList.length; i++)
				{
					if(player.isResearchObjectComplete(prereqList[i])) //if this prereq is complete, return true and break loop
					{
						ret = true;
						break;
					}
				}
			}
			
			return ret;
		}
		
		public function onCompleted():void
		{
			//to be overwritten by other objects.
			//Go into race.player and use its unit and building list to effect all units or buildings currently in use.
			//on creation of new units or buildings, they will check to see if the research has been completed to see what attributes
			//need to be different
			
			//For example:
			//if this research effects infantry armor type. Go find the unit list owned by the player using race.player.unitList. find every instance
			//of an infantry unit currently in play and change its armor type.
			//when new infantry are built, the constructor will check if this research has been completed, and then set the armor type accordingly.
			
			//any research that adds new menus or abilities will just be a simple check to see if the research has been done first
			
			//also set selected = false and player.activeResearch = null when completed
		}
		
		//goes to the frame where its selected
		public function setSelected():void
		{
			this.gotoAndStop("researchSelected");
			
			if(player.activeResearch != null && player.activeResearch != this) //if active research isnt null and isn't this one already
			{
				player.activeResearch.setDefault(); //set the current active research to default	
			}
			
			player.activeResearch = this; //sets the active research to this
			selected = true; //sets selected to true
		}
		
		//goes to the frame where its finished
		public function setFinished():void
		{
			this.gotoAndStop("researchFinished");
		}
		
		//goes to the frame where its not available
		public function setNotAvailable():void
		{
			this.gotoAndStop("researchNotAvailable");
		}
		
		//goes to the default frame
		public function setDefault():void
		{
			this.gotoAndStop(0);
			selected = false; //sets selected to false so that it doesn't show up as selected next time
		}
	}
}