package main
{
	import flash.display.MovieClip;
	import Buttons.*;
	
	public class PopUpMenu extends MovieClip
	{
		public var list:Array = new Array();
		public function PopUpMenu()
		{
			super();
		}
		
		public function addToList(button:MovieClip):void
		{
			list.push(button);
		}
		
		public function displayList():void
		{
			for(var i=0; i < list.length; i++)
			{
				list[i].x = -195;
				list[i].y = 25 + (40*i);
				this.addChild(list[i]);
			}
		}
		
		public function clearList():void
		{
			list = null;
			list = new Array();
			list.push(new infoButton()); //clear the list and re-add the old info Button
		}
	}
}