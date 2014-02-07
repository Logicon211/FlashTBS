package Research
{
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	public class ResearchWindow extends MovieClip
	{
		var researchContainer:MovieClip
		public var researchList:Array = new Array();
		
		var textFormat:TextFormat; //text format passed in so that it can be used to display proper font on the research info window, and any on this current window
		var researchInfoWindow:ResearchInfoWindow;
		
		public function ResearchWindow(txtFormat:TextFormat)
		{
			super();
			
			textFormat = txtFormat; //sets the font to the games default
			
			researchContainer = new MovieClip();
			
			this.addChild(researchContainer);
			
			researchContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragContainer, false, 0, true);
			researchContainer.addEventListener(MouseEvent.MOUSE_UP, dropContainer, false, 0, true);
		}
		
		public function addResearchItem(item:ResearchItem):void
		{
			//set coordinates to those determined in its own class
			item.x = item.xCord;
			item.y = item.yCord;
			
			//will need to have an intermittent movieclip to store these items one so we can drag the whole thing like the map
			researchContainer.addChild(item);			
			//add prerequisite lines in here
			for(var i:int = 0; i < item.prereqList.length; i++)
			{
				researchContainer.graphics.lineStyle(5);
				
				researchContainer.graphics.moveTo(item.xCord + (item.width/2), item.yCord);
				researchContainer.graphics.lineTo(item.prereqList[i].xCord + (item.prereqList[i].width/2), item.prereqList[i].yCord + item.prereqList[i].height);
			}
			
			if(item.getSelected())
			{
				item.setSelected(); //sets the graphic to selected
			}
			else if(item.isComplete())
			{
				item.setFinished(); //sets the graphic to finished
			}
			else if(!item.isAvailable()) //if it isn't available, set the graphic and don't add the listener
			{
				item.setNotAvailable(); //sets the graphic to not available
			}
			else
			{
				item.setDefault();
			}

		}
		
		//Selects the research item to be set as current research
		public function selectResearchItem(e:MouseEvent):void
		{
			if(!e.target.isComplete() && e.target.isAvailable() && !e.target.getSelected()) //if the item isn't complete, is available and isn't already selected
			{
				e.target.setSelected(); //set the target to selected
			}
		}
		
		//adds the research list to be displayed
		public function addResearchList(list:Array):void
		{
			researchList = new Array(list.length);
			for(var i:int = 0; i < list.length; i++) //goes through the given list and take each item into the researchList
			{
				researchList[i] = list[i];
				addResearchItem(researchList[i]); //add it to the window to display it.
				researchList[i].addEventListener(MouseEvent.MOUSE_DOWN, selectResearchItem, false, 0, true); //addsthe listener to be clicked
				researchList[i].addEventListener(MouseEvent.MOUSE_OVER, researchItemHover, false, 0, true); //addsthe listener to be moused over
				researchList[i].addEventListener(MouseEvent.MOUSE_OUT, researchItemOut, false, 0, true); //addsthe listener to see when mouse stops hovering over
			}

		}
		
		//Drag container button
		function dragContainer(e:MouseEvent):void
		{
			researchContainer.startDrag(false);
		}
		
		//stop Drag container
		function dropContainer(e:MouseEvent):void
		{
			researchContainer.stopDrag();
		}
		
		//when the mouse hovers over the research item, it creates a researchinfo window and has it stay over the mouse until it mouses out
		function researchItemHover(e:MouseEvent):void
		{
			researchInfoWindow = new ResearchInfoWindow(textFormat, e.target as ResearchItem);
			researchInfoWindow.addEventListener(Event.ENTER_FRAME, keepWindowOnMouse, false, 0, true); //adds event so that the window moves with the mouse
			researchInfoWindow.x = mouseX;
			researchInfoWindow.y = mouseY;
			this.addChild(researchInfoWindow);
		}
		
		//removes the research info window when the mouse moused out of the research item
		function researchItemOut(e:MouseEvent):void
		{
			researchInfoWindow.removeEventListener(Event.ENTER_FRAME, keepWindowOnMouse, false); //removes the event listener
			this.removeChild(researchInfoWindow);
			researchInfoWindow = null;
		}
		
		//this functions keeps the info window hovering over the mouse
		function keepWindowOnMouse (e:Event):void
		{
			if(researchInfoWindow != null)
			{
				researchInfoWindow.x = mouseX;
				researchInfoWindow.y = mouseY;
			}
		}
	}
}