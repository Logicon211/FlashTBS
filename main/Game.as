package main
{
	import Buildings.*;
	
	import Buttons.*;
	
	import CustomEvents.*;
	
	import GameMaps.GameMap;
	import GameMaps.TestMap;
	
	import Graphics.*;
	
	import Map.*;
	
	import Planets.Planet;
	
	import Player.*;
	
	import Research.ResearchItem;
	import Research.ResearchWindow;
	
	import Units.*;
	
	import caurina.transitions.*;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	public class Game extends MovieClip
	{
		/*GLOBAL VARIABLES FOR MAIN GAME FUNCTION*/
		
		//Pop-Up menu object that gets created on a map-tile click
		public var popUpMenu:PopUpMenu;
		
		//infoWindow for information on map tiles
		public var infoWindow:InfoWindow; 
		
		//Status window to keep track on information easy in the top left or bottom left
		public var statusWindow:StatusWindow;
		
		//Quick info window in the bottom left corner to show information that might be needed
		public var quickInfoWindow:QuickInfoWindow;
		
		//Build window for constructing units
		public var buildWindow:BuildWindow;
		
		//Button info window shows up when hovering over menu buttons
		public var buttonInfoWindow:ButtonInfoWindow;
		
		//Research window
		public var researchWindow:ResearchWindow;
		
		// Boolean to check if the menu is up already
		public var isMenuUp:Boolean = false;
		
		//Placeholder for a map that can be loaded
		public var selectedMap:GameMap; //Overall Map that contains it's name, description, etc 
		public var map:Array; //Map array that will be changed whenever the player navigates from planets to space
		
		//Coordinates of mouse movement used for map dragging
		public var currentMouseX:int;
		public var currentMouseY:int;
		
		//Movieclip to hold all maptiles in the array, needed to be grouped for easy dragging
		public var mapContainer:MapContainer;
		
		//Selected tiles, units, and secondary tiles all needed for important functions like movement, and information
		public var selectedUnit:Unit;
		public var selectedTile:MapTile; //first tile clicked
		public var selectedSecondTile:MapTile; //second tile clicked
		public var selectedBuilding:Building; //selected building, only used when we're waiting for a building to attack a unit
		public var shortestPath:Array = new Array(); //shortest path generated between 2 points
		public var currentPlanet:Planet = null; //Current planet being viewed
		//var currentCost:int = 0; //Used in keypad movement to keep track of current move cost
		
		//States the game is in at current points in time.
		public var waitingForMoveSelection:Boolean = false; //after a unit is clicked
		public var waitingForMoveConfirm:Boolean = false; //after a tile is clicked for unit movement
		public var waitingForAttack:Boolean = false; //After a unit is moved and possible attack options are available
		public var disableMapClicks:Boolean = false; //Used to disable map clicks while looking at info screens
		public var hitEnemyUnit:Boolean = false; //is used when movement ends to see if a unit was trapped during movement due to FOW
		public var unitMoved:Boolean = false; //used to check if an indirect fire unit has moved during its turn.
		
		//Text font info for the majority of text in the game
		public var txtFont:OCRFont = new OCRFont();
		public var txtFormat:TextFormat = new TextFormat(txtFont.fontName, 20); //regular font for most things
		public var statusFormat:TextFormat = new TextFormat(txtFont.fontName,10); //smaller size font for the status window
		
		//if the info button is pressed after unit movement and are waiting to finish (done, attack, special ability, etc). Closing the info screen won't return map control until a finish button is pressed
		public var finishButtonAvailable = false;
		
		//Array of players in the game
		public var players:Array = new Array();
		
		//Who's turn it currently is
		public var turn:BasePlayer;
		
		public function Game()
		{
			super();
			
			//initializing players, will probably move this later when game setup needs to be put in
			players.push(new HumanPlayer(1,5000,10));//player1
			players.push(new HumanPlayer(2,1000,10));//player2
			
			turn = players[0]; //sets first turn to player 1, testing purposes
			
			//add statusWindow
			statusWindow = new StatusWindow(statusFormat);
			statusWindow.x = 0;
			statusWindow.y = 0;
			stage.addChild(statusWindow);

			mapContainer = new MapContainer();
			
			selectedMap = new TestMap(); //Load test map, this will be removed after testing is finished
			map = selectedMap.ConstructMap(2, players); //Construct map with 2 players, passing the array in to initialize units/buildings
			initializeMap(map, selectedMap.getWidth(), selectedMap.getHeight()); //initialize map with it's listeners to the map container
			
			//add Quick info window
			quickInfoWindow = new QuickInfoWindow(statusFormat);
			quickInfoWindow.x = 0;
			quickInfoWindow.y = stage.stageHeight;
			
			stage.addChild(quickInfoWindow);

			//Initialize Button info window
			buttonInfoWindow = new ButtonInfoWindow(txtFormat);
			buttonInfoWindow.x = 175;
			buttonInfoWindow.y = stage.stageHeight - buttonInfoWindow.height - 40;
			buttonInfoWindow.visible = false; //not visible initially
			
			//Adds listeners for keyboard functions
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyFunctions);
			
		}
		
		public function initializeMap(mapToInitialize:Array, width:int, height:int) //function to initialize the map with it's appropriate listeners and to display it on stage
		{
			
			for(var i:Number = 0;i < height;i++){ //Heigth
				for(var j:Number = 0;j < width;j++) { //Width
					
					mapToInitialize[i][j].addEventListener(MouseEvent.MOUSE_UP, tileClicked, false, 0, true); //remove this once I figure out how to get it in MapTile
					mapToInitialize[i][j].addEventListener(MouseEvent.MOUSE_OVER,updateQuickInfo, false, 0, true); //when moused over, quick info window will display info about tile
					mapContainer.addChild(mapToInitialize[i][j]);
					
					stage.addChild(mapContainer); //Add the map container to the stage
					stage.setChildIndex(mapContainer, 1) //sets the map in behind all other UI elements
					addMapListeners()//Add map control listeners (dragging etc)
					
					Utils.calculateVision(map, turn); //initialize fog on Map load
					
				}
			}
			
			//Utils.calculateVision(map, turn); //initialize fog on Map load
			
			statusWindow.updateInfo(turn, currentPlanet);
		}
		
		public function tileClicked(event:MouseEvent) //this is essentially the function to handle the entire game here.
		{
			if((currentMouseX > mouseX - 10 && currentMouseX < mouseX + 10) && (currentMouseY > mouseY - 10 && currentMouseY < mouseY + 10) && !disableMapClicks) //checks to see if the map was dragged and not clicked, + if map clicks are not disabled
			{
				
				if(event.currentTarget is MapTile)//Below is a set of conditions and actions to perform on those sets of conditions
				{
					if(event.currentTarget.hasBuilding() && event.currentTarget.building.offensiveCapable && event.currentTarget.building.player == turn && event.currentTarget.building.canFire() && event.currentTarget.hasUnit() && !event.currentTarget.unit.DoneTurn() && event.currentTarget.unit.player == turn) //If we've clicked on a building that can attack who also has a unit on it as well on the current players turn
					{
						//add selected units/tiles to the tile we clicked on
						selectedTile = event.currentTarget as MapTile;
						selectedSecondTile = event.currentTarget as MapTile; //setting both tiles due to them both being needed later on
						selectedUnit = event.currentTarget.unit; //set selected unit as the tile we clicked on						
						
						popUpMenu = new PopUpMenu(); //Will add more buttons to list using unit abilities or something
						
						popUpMenu.list.push(new infoButton()); //add the info button to the list

						if(selectedSecondTile.hasBuilding() && selectedSecondTile.building.player == turn) //If selected tile has building, and the building is owned by current player, include building abilities in menu. Will need to include A check to see if the building is player owned
						{
							var abilities:Array = selectedSecondTile.building.getAbilities(selectedSecondTile.hasUnit(), (Utils.testBuildingRange(selectedSecondTile, selectedSecondTile.building.maxRange, selectedSecondTile.building, turn) && !Utils.testBuildingRange(selectedSecondTile, selectedSecondTile.building.minRange, selectedSecondTile.building, turn))) //get the abilities of the building and add them to an array
																															//^^ this is to test if the building is within range AND out of minimum range
							for(i = 0; i < abilities.length; i++)//add all ability buttons to the popUpMenu
							{
								popUpMenu.addToList(abilities[i]);
							}
						}

						popUpMenu.list.push(new moveButton()); //add the move button for the unit on the same tile
						
						popUpMenu.x = 1024; //Displays menu in top right corner. WILL NEED TO ADD COLLISION DETECTION FOR CURRENT TILE
						popUpMenu.y = stage.stageHeight - popUpMenu.height;
						stage.addChild(popUpMenu);
						
						popUpMenu.displayList();
						for(var l:int=0; l<popUpMenu.list.length; l++) //add listeners to the buttons in the menu
							
						{
							popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_UP, HandleButton, false, 0, true);
							popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OVER, mouseOverButton, false, 0, true);
							popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OUT, mouseOutButton, false, 0, true);
						}
						isMenuUp = true;
						
						disableMapClicks = true; //turn off map control until this process is finished
					}
					else if(event.currentTarget.hasUnit() && !event.currentTarget.unit.DoneTurn() && event.currentTarget.unit.player == turn && !waitingForMoveSelection && !waitingForMoveConfirm) //if selected tile has a unit, and that unit has not done their turn, and that unit is owned by the player whos turn it is, and we're not waiting on a Move Confirmation or Move Selection
					{
						//run method to show movement tiles
						Utils.showMoveTiles(event.currentTarget as MapTile, event.currentTarget.unit.movement, event.currentTarget.unit);
						waitingForMoveSelection = true;
						selectedUnit = event.currentTarget.unit;
						selectedTile = event.currentTarget as MapTile;
						selectedSecondTile = event.currentTarget as MapTile; //second tile is set to this tile as well for keyboard movement
						shortestPath.unshift(selectedTile); //add the current tile to selectedMoveTile, for keyboard movement
						
						moveMap(selectedTile.x, selectedTile.y);
						
						closePopUpMenu(); //Closes popup menu if its up
					}
					
					else if(waitingForMoveSelection && event.currentTarget.canMove && (!event.currentTarget.hasUnit() || event.currentTarget.unit == selectedUnit || !event.currentTarget.isVisible)) //if we're waiting for movement selection, and selected tile is available for movement and the selected tile doesnt have a unit (Or if it does, its the same unit we're controlling so its ok, or it isn't visible so theres a possiblity for a unit to be caught)
					{
						
						shortestPath = PathFinder.go(selectedTile, event.currentTarget as MapTile, map, selectedUnit); //find shortest path using algorithm, put path in array
						Utils.showMoveLines(shortestPath, map); //generate movement arrows according to path;
						
						selectedSecondTile = event.currentTarget as MapTile;
						
						waitingForMoveConfirm = true; //now waiting on move concfirmation
						waitingForMoveSelection = false;
						
						if(selectedTile == selectedSecondTile) //If the tile clicked is the unit's starting position. Just jump to doneMovement
						{
							selectedTile.removeUnit(); //remove unit from tile and place him in the mapContainer, overtop of the maptiles. This is needed because the unit graphic will always lie underneath the maptiles due to the fact that it is a child to only one maptile parent
							selectedUnit.x = selectedTile.x; 
							selectedUnit.y = selectedTile.y;
							mapContainer.addChild(selectedUnit);
							
							Utils.removeMoveTiles(selectedTile, selectedUnit.movement, selectedUnit); //remove move animation boxes
							
							doneMovement();
						}
					}
					
					else if(waitingForMoveConfirm && event.currentTarget.canMove) //If we are waiting on Move Confirmation and the current tile clicked is available for movement
					{
						if(selectedTile == selectedSecondTile && event.currentTarget == selectedSecondTile) //if the selected tile is confirmed again and If the tile clicked is the unit's starting position. Just jump to doneMovement without doing any tweens
						{
							selectedTile.removeUnit(); //remove unit from tile and place him in the mapContainer, overtop of the maptiles. This is needed because the unit graphic will always lie underneath the maptiles due to the fact that it is a child to only one maptile parent
							selectedUnit.x = selectedTile.x; 
							selectedUnit.y = selectedTile.y;
							mapContainer.addChild(selectedUnit);
							
							Utils.removeMoveTiles(selectedTile, selectedUnit.movement, selectedUnit); //remove move animation boxes
							shortestPath = new Array(); //reset shortest path
							
							doneMovement();
						}
						else if(event.currentTarget  == selectedSecondTile && (!event.currentTarget.hasUnit() || !event.currentTarget.isVisible)) //if the selected tile is confirmed again AND doesn't have a unit on it OR if it does, the tile is not visible (therefor maybe trapped).
						{
							selectedTile.removeUnit(); //remove unit from tile and place him in the mapContainer, overtop of the maptiles. This is needed because the unit graphic will always lie underneath the maptiles due to the fact that it is a child to only one maptile parent
							selectedUnit.x = selectedTile.x; 
							selectedUnit.y = selectedTile.y;
							mapContainer.addChild(selectedUnit);
							
							//Check for unit being trapped by other units in FOW
							for(var i:int = shortestPath.length - 1; i>=0; i--)
							{
								if(shortestPath[i].hasUnit() && shortestPath[i].unit.player != turn) //if tile has unit which is not owned by the player whos turn it is
								{
									selectedSecondTile = shortestPath[i+1]; //sets the selectedSecondTile to the tile right before it was trapped
									Utils.removeMoveLines(shortestPath);//remove move lines as well as tile Movement animations early because the path will be edited
									shortestPath.splice(0, i+1); //creates a new shortestPath with the unit who attempted to move through another enemy unit
									i = -1; //end the check for units, we only need to find the first one
									hitEnemyUnit = true; //hitEnemyUnit is true because unit was trapped, will be resolved in doneMovement()
								}
							}
							
							selectedUnit.addMovementEventListener(); //the unit is now checking to see which movement animation direction to use.
							var tweenMove:Tween; //tween object for tweening movement
							//this loops runs through the shortestPath Array and tweens the motion from start to finish
							for(var g:int = shortestPath.length - 1; g>=1; g--)
							{
								if(g == 1) //if we're on the last tween tile, call the doneTween function once finished
								{
									if(shortestPath[g].xCord != shortestPath[g-1].xCord)
									{
										Tweener.addTween(selectedUnit, {x:shortestPath[g-1].x, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear", onComplete:doneMovement}); 
									}
									else if(shortestPath[g].yCord != shortestPath[g-1].yCord)
									{
										Tweener.addTween(selectedUnit, {y:shortestPath[g-1].y, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear", onComplete:doneMovement});
									}
								}
								else // else just do the tween
								{
									if(shortestPath[g].xCord != shortestPath[g-1].xCord)
									{
										Tweener.addTween(selectedUnit, {x:shortestPath[g-1].x, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear"}); 
									}
									else if(shortestPath[g].yCord != shortestPath[g-1].yCord)
									{
										Tweener.addTween(selectedUnit, {y:shortestPath[g-1].y, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear"});
									}
								}
							}
							
							Utils.removeMoveTiles(selectedTile, selectedUnit.movement, selectedUnit);
							Utils.removeMoveLines(shortestPath);//remove move lines as well as tile Movement animations 
							shortestPath = new Array(); //reset shortest path as we do not want this array to interfere with new paths to make
							
							//All actions after this have been moved to the doneMove function, as they are all supposed to be done AFTER animation
							
							//GoTo doneMove() for actions after the movement
	
						}
						else if(!event.currentTarget.hasUnit() || event.currentTarget.unit == selectedUnit || !event.currentTarget.isVisible) //if the selected tile wasn't the same as the last one and it doesn't have a unit on it already or if the tile has the unit we're currently controlling, or the tile isn't visible (possiblility to be trapped). redraw the movement lines to fit the new selection (TL;DR: New legal movement tile was clicked instead of confirmed)
						{
							Utils.removeMoveLines(shortestPath);
							shortestPath = PathFinder.go(selectedTile, event.currentTarget as MapTile, map, selectedUnit); //find shortest path using algorithm, put path in array
							Utils.showMoveLines(shortestPath, map); //generate movement arrows according to path;
							selectedSecondTile = event.currentTarget as MapTile;
						}
					}
					
					else if(!isMenuUp && !waitingForMoveConfirm && !waitingForMoveSelection) //If Menu is not up, and we're not waiting for Move or Move Selection
					{
						selectedSecondTile = event.currentTarget as MapTile; //selectedTile is set so we can pass it to functions that need it in the menu

						popUpMenu = new PopUpMenu(); //Will add more buttons to list using unit abilities or something
						
						popUpMenu.list.push(new infoButton()); //add the info button to the list
						
						if(selectedSecondTile.hasBuilding() && selectedSecondTile.building.player == turn) //If selected tile has building, and the building is owned by current player, include building abilities in menu. Will need to include A check to see if the building is player owned
						{
							var abilities:Array = selectedSecondTile.building.getAbilities(selectedSecondTile.hasUnit(), (Utils.testBuildingRange(selectedSecondTile, selectedSecondTile.building.maxRange, selectedSecondTile.building, turn) && !Utils.testBuildingRange(selectedSecondTile, selectedSecondTile.building.minRange, selectedSecondTile.building, turn))) //get the abilities of the building and add them to an array //get the abilities of the building and add them to an array
																																//^^ this is to test if the building is within range AND out of minimum range
							for(i = 0; i < abilities.length; i++)//add all ability buttons to the popUpMenu
							{
								popUpMenu.addToList(abilities[i]);
							}
						}
						
						if(selectedSecondTile.hasPlanet()) //if the tile clicked has a planet
						{								
							popUpMenu.addToList(new gotoPlanetButton()) //add menu button to enter planet 
						}
						else if (currentPlanet != null)
						{
							popUpMenu.addToList(new exitPlanetButton()) //add menu button to exit planet
						}
						
						popUpMenu.addToList(new endButton()); //Adds the end turn button to the menu
						
						popUpMenu.x = 1024; //Displays menu in top right corner. WILL NEED TO ADD COLLISION DETECTION FOR CURRENT TILE
						popUpMenu.y = stage.stageHeight - popUpMenu.height;
						stage.addChild(popUpMenu);
						
						popUpMenu.displayList();
						for(var l:int=0; l<popUpMenu.list.length; l++) //add listeners to the buttons in the menu
							
						{
							popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_UP, HandleButton, false, 0, true);
							popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OVER, mouseOverButton, false, 0, true);
							popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OUT, mouseOutButton, false, 0, true);
						}
						isMenuUp = true;
					}
				}
				trace("Clicked: " + event.currentTarget.xCord + "," + event.currentTarget.yCord);
			}
			//Below this are map clicks while the game is in a certain state (Like waiting for attack selection, or choosing an area to orbitally bombard, etc
			else if ((currentMouseX > mouseX - 10 && currentMouseX < mouseX + 10) && (currentMouseY > mouseY - 10 && currentMouseY < mouseY + 10) && waitingForAttack) //Map is clicked (not dragged) while waiting for an attack selection
			{
				if(event.currentTarget is MapTile)//Below is a set of conditions and actions to perform on those sets of conditions
				{
					if(event.currentTarget.canAttack && Utils.canAttackTile(event.currentTarget as MapTile, turn, selectedUnit, selectedBuilding)) //if selected tile is marked as an attack tile and that the unit/building can attack the tile (needs to have an enemy unit/building etc)
					{
						if(selectedBuilding == null) //if it's not a building attacking (Ie a unit)
						{
							Utils.removeAttackTiles(selectedSecondTile, selectedUnit.maxRange, selectedUnit); //remove the attack tile animations
							Utils.revealFog(event.currentTarget as MapTile, selectedUnit.vision, turn); //recalculate vision before unit attacks (as it probably moved)
							
							selectedUnit.dispatchEvent(new FireEvent("fire", event.currentTarget as MapTile)); //dispatch a fire event from the selected unit on the current mapTile Target
						
							//check to see if its a unit or a building we're attacking (unit's take precedence)
							if(event.currentTarget.hasUnit() && event.currentTarget.unit.player != turn) //if we're attacking a unit not on the current turns team
							{
								event.currentTarget.unit.takeDamage(selectedUnit.calculateDamage(event.currentTarget as MapTile)); //defender takes damage
							}
							else if(event.currentTarget.hasBuilding() && event.currentTarget.building.player != turn) //else we're attacking a building
							{	
								event.currentTarget.building.takeDamage(selectedUnit.calculateDamage(event.currentTarget as MapTile)) //defending  building takes damage
							}
						
							// check if the defender (a unit, not a building) is still alive, neither the attacker nor defender is indirect, and is within range (BUT NOT within minimum range) to retaliate, if so, perform a retaliation
							if(event.currentTarget.hasUnit()  && event.currentTarget.unit.player != turn && !selectedUnit.isIndirect && !event.currentTarget.unit.isIndirect && Utils.testRange(event.currentTarget as MapTile, event.currentTarget.unit.maxRange, selectedUnit, turn, event.currentTarget.unit))
							{
								event.currentTarget.unit.dispatchEvent(new DefendEvent("defend")); //defending unit dispatches defend event,
								event.currentTarget.unit.dispatchEvent(new FireEvent("fire", selectedUnit.location)); //defending unit dispatches defend attack event as well for retaliation
								selectedUnit.takeDamage(event.currentTarget.unit.calculateDamage(selectedSecondTile)); //attacker takes retaliation damage
								
								//if the original attacker is still alive, have it dispatch a defend event
								if(selectedUnit.location.hasUnit()) //(The reason we're using selectedUnit.Location is because it's the only maptile we have available to check. And selectedUnit won't get removed from memory until the turn finishes
								{
									selectedUnit.dispatchEvent(new DefendEvent("defend"));
								}
							}
						
							selectedUnit.finishTurn(); //finish the attacking units turn
							finishButtonAvailable = false; //Unit finished turn, so there's no finish button now.
						}
						else //if it is a building attacking
						{
							Utils.removeAttackTiles(selectedSecondTile, selectedBuilding.maxRange, null, selectedBuilding)
							
							//check to see if its a unit or a building we're attacking (unit's take precedence)
							if(event.currentTarget.hasUnit() && event.currentTarget.unit.player != turn) //if we're attacking a unit not on the current turns team
							{
								event.currentTarget.unit.takeDamage(selectedBuilding.calculateDamage(event.currentTarget as MapTile)); //defender takes damage
								
								if(event.currentTarget.hasUnit()) //if the unit is still alive, dispatch a defend event on it
								{
									event.currentTarget.unit.dispatchEvent(new DefendEvent("defend"));
								}
							}
							else if(event.currentTarget.hasBuilding() && event.currentTarget.building.player != turn) //else we're attacking a building
							{	
								event.currentTarget.building.takeDamage(selectedBuilding.calculateDamage(event.currentTarget as MapTile)) //defending  building takes damage
							}
							
							selectedBuilding.firedWeapon(); //Building cannot fire again this turn
						}
						
						waitingForAttack = false; //attack is done, end state
						disableMapClicks = false; //re-enable map control
						closePopUpMenu(); //close the popUpMenu if its up
						clearSelectedData(); //Clear selected units
					}
				}
			}
		}
		
		//This function is called immediately after a tween movement has finished. It finished up movement animations and placement, and initialized the popup menu
		public function doneMovement():void
		{
			selectedUnit.removeMovementEventListener();
			
			if(selectedTile != selectedSecondTile) //if the first and second tiles are different the unit has moved.
			{
				unitMoved = true;
			}
			else
			{
				unitMoved = false;
			}
			
			mapContainer.removeChild(selectedUnit); //remove the child from the outside mapContainer and add it to the current selected move tile
			selectedSecondTile.addUnit(selectedUnit);
			
			//BELOW IS IMPORTANT<<< ALL ACTIONS ARE NOW TO BE DETERMINED AND DISPLAYED ON THE MENU AFTER MOVEMENT
			if(!isMenuUp && !hitEnemyUnit) //If menu isnt up AND during movement the unit DID NOT hit an enemy unit
			{
				//Conditions for unit abilities below
				var enemyWithinRange:Boolean = false;
				
				if(Utils.testRange(selectedSecondTile, selectedUnit.maxRange, selectedUnit, turn) && !Utils.testRange(selectedSecondTile, selectedUnit.minRange, selectedUnit, turn)) //checks to see if an enemy unit is within range and NOT within minimum range to the currently selected unit
				{
					enemyWithinRange = true;
				}
				
				if (enemyWithinRange && !(selectedUnit.isIndirect && unitMoved)) //if there's an enemy within range, and this unit isn't indirect and moved.
				{
					waitingForAttack = true;
					Utils.showAttackTiles(selectedSecondTile, selectedUnit.maxRange, selectedUnit.minRange, selectedUnit);
				}
				
				popUpMenu = new PopUpMenu();
				
				var abilities:Array = selectedUnit.getAbilities(enemyWithinRange, selectedSecondTile); //Get abilities from selected unit (Will add more conditions later)
				
				popUpMenu.list.push(new infoButton()); //add the info button to the list
				
				for(var i:int = 0; i<abilities.length; i++) //add them to the menu 1 at a time
				{
					popUpMenu.addToList(abilities[i]);
				}
				
				popUpMenu.addToList(new cancelButton()); //adds the cancel button to the list, allowing to retract moves
				popUpMenu.addToList(new doneButton()); //Will add more buttons to list using unit abilities or something, done button just finishes movement without any action
				
				finishButtonAvailable = true; //makes sure map won't be reenabled until the done button is pressed (Or attack or whatever)
				
				popUpMenu.x = 1024; //Displays menu in bottom right corner.
				popUpMenu.y = stage.stageHeight - popUpMenu.height;;
				stage.addChild(popUpMenu);
				
				popUpMenu.displayList();
				for(var l=0; l<popUpMenu.list.length; l++) //add listeners to the buttons in the menu
					
				{
					popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_UP, HandleButton, false, 0, true);
					popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OVER, mouseOverButton, false, 0, true);
					popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OUT, mouseOutButton, false, 0, true);
				}
				isMenuUp = true;
				
				//remove ability to interact with map until movement is done
				disableMapClicks = true;
			}
			
			else if(hitEnemyUnit) //If the unit hit an enemy unit during movement, then it is trapped and it loses its turn, Menu does not come up
			{
				trace("Unit Trapped!");
				//add the graphic that pops up when unit becomes trapped
				var TG:trapGraphic = new trapGraphic();
				TG.x = (selectedSecondTile.xCord * 50) + mapContainer.x + 25;
				TG.y = (selectedSecondTile.yCord * 50) + mapContainer.y;
				stage.addChild(TG);
					
				Utils.revealFog(selectedSecondTile, selectedUnit.vision, turn);// reveal fog from this new unit placement
				selectedUnit.finishTurn(); //finish units turn immediately
				hitEnemyUnit = false; //reset the hit enemy unit check
			}
			
			waitingForMoveConfirm = false;
		}
		
		public function keyFunctions(e:KeyboardEvent) //Event handler for key presses like the arrow keys or other hot keys
		{
			if(waitingForMoveSelection || waitingForMoveConfirm) //if we're waiting for move selection or confirmation
			{
				var currentCost:int;
				
				if(e.keyCode == 38) //Keycode UP ARROW
				{
					if(selectedSecondTile.northTile != null && selectedSecondTile.northTile.canMove) //checking if the tile we want to go to is legal
					{
						//calculates current cost on the path we have already
						for(var i:int = 0; i < shortestPath.length - 1; i++)
						{
							currentCost = currentCost + shortestPath[i].getCost(selectedUnit);
						}
					
						if(shortestPath[1] == selectedSecondTile.northTile)  //backtracking because last movement was down
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.shift();
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.northTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement >= selectedSecondTile.northTile.getCost(selectedUnit) + currentCost) //checking to see if cost has gone over limit
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.unshift(selectedSecondTile.northTile); //add this new tile to the beginning (as the array is read in reverse)
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.northTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement < selectedSecondTile.northTile.getCost(selectedUnit) + currentCost) //if it IS greater than the total cost, than just find the shortest path to it instead
						{
							Utils.removeMoveLines(shortestPath);
							selectedSecondTile = selectedSecondTile.northTile;
							shortestPath = PathFinder.go(selectedTile, selectedSecondTile, map, selectedUnit); //Find the shortest path from unit beginning to the new selection
							Utils.showMoveLines(shortestPath, map); //show new move lines
						}
					}

				}
				else if(e.keyCode == 39) //Keycode RIGHT ARROW
				{
					if(selectedSecondTile.eastTile != null && selectedSecondTile.eastTile.canMove)//checking if the tile we want to go to is legal
					{
						//calculates current cost on the path we have already
						for(i = 0; i < shortestPath.length - 1; i++)
						{
							currentCost = currentCost + shortestPath[i].getCost(selectedUnit);
						}
					
						if(shortestPath[1] == selectedSecondTile.eastTile)  //backtracking because last movement was left
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.shift();
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.eastTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement >= selectedSecondTile.eastTile.getCost(selectedUnit) + currentCost) //checking to see if cost has gone over limit
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.unshift(selectedSecondTile.eastTile); //add this new tile to the beginning (as the array is read in reverse)
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.eastTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement < selectedSecondTile.eastTile.getCost(selectedUnit) + currentCost) //if it IS greater than the total cost, than just find the shortest path to it instead
						{
							Utils.removeMoveLines(shortestPath);
							selectedSecondTile = selectedSecondTile.eastTile;
							shortestPath = PathFinder.go(selectedTile, selectedSecondTile, map, selectedUnit); //Find the shortest path from unit beginning to the new selection
							Utils.showMoveLines(shortestPath, map); //show new move lines
						}
					}
				}
				else if(e.keyCode == 40) //Keycode DOWN ARROW
				{
					if(selectedSecondTile.southTile != null && selectedSecondTile.southTile.canMove)//checking if the tile we want to go to is legal
					{
						//calculates current cost on the path we have already
						for(i = 0; i < shortestPath.length - 1; i++)
						{
							currentCost = currentCost + shortestPath[i].getCost(selectedUnit);
						}
					
						if(shortestPath[1] == selectedSecondTile.southTile)  //backtracking because last movement was right
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.shift();
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.southTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement >= selectedSecondTile.southTile.getCost(selectedUnit) + currentCost) //checking to see if cost has gone over limit
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.unshift(selectedSecondTile.southTile); //add this new tile to the beginning (as the array is read in reverse)
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.southTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement < selectedSecondTile.southTile.getCost(selectedUnit) + currentCost) //if it IS greater than the total cost, than just find the shortest path to it instead
						{
							Utils.removeMoveLines(shortestPath);
							selectedSecondTile = selectedSecondTile.southTile;
							shortestPath = PathFinder.go(selectedTile, selectedSecondTile, map, selectedUnit); //Find the shortest path from unit beginning to the new selection
							Utils.showMoveLines(shortestPath, map); //show new move lines
						}
					}
	
				}
				else if(e.keyCode == 37) //Keycode LEFT ARROW
				{
					if(selectedSecondTile.westTile != null && selectedSecondTile.westTile.canMove)//checking if the tile we want to go to is legal
					{
						//calculates current cost on the path we have already
						for(i = 0; i < shortestPath.length - 1; i++)
						{
							currentCost = currentCost + shortestPath[i].getCost(selectedUnit);
						}
					
						if(shortestPath[1] == selectedSecondTile.westTile)  //backtracking because last movement was up
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.shift();
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.westTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement >= selectedSecondTile.westTile.getCost(selectedUnit) + currentCost) //checking to see if cost has gone over limit
						{
							Utils.removeMoveLines(shortestPath); //clears the map of current move lines
							shortestPath.unshift(selectedSecondTile.westTile); //add this new tile to the beginning (as the array is read in reverse)
							Utils.showMoveLines(shortestPath, map); //show new move lines
							selectedSecondTile = selectedSecondTile.westTile; //set the new second tile as the main one
						}
						else if(selectedUnit.movement < selectedSecondTile.westTile.getCost(selectedUnit) + currentCost) //if it IS greater than the total cost, than just find the shortest path to it instead
						{
							Utils.removeMoveLines(shortestPath);
							selectedSecondTile = selectedSecondTile.westTile;
							shortestPath = PathFinder.go(selectedTile, selectedSecondTile, map, selectedUnit); //Find the shortest path from unit beginning to the new selection
							Utils.showMoveLines(shortestPath, map); //show new move lines
						}
					}
					
				}
				waitingForMoveSelection = false;
				waitingForMoveConfirm = true; //regardless of what state we were before, we will be in confirmation state now
				
				if(e.keyCode == 13) // The enter button is the hotkey to complete movement
				{
					var canContinue:Boolean = true; //this is a check to see if we can finish the code at the bottom of this function
					
					if(selectedSecondTile.hasUnit() && selectedSecondTile.unit != selectedUnit && selectedSecondTile.isVisible) //if the selected tile has a unit (Which isn't itself), most likely a friendly one, we can't complete movement in the same tile, so essentially, do nothing
					{
						canContinue = false;
					}
					else if(selectedTile == selectedSecondTile) //if the unit hasn't moved
					{
						//not really necessary, but it is because doneMovement removes a unit from the stage regardless
						selectedTile.removeUnit(); //remove unit from tile and place him in the mapContainer, overtop of the maptiles. This is needed because the unit graphic will always lie underneath the maptiles due to the fact that it is a child to only one maptile parent
						selectedUnit.x = selectedTile.x; 
						selectedUnit.y = selectedTile.y;
						mapContainer.addChild(selectedUnit);
						
						Utils.removeMoveTiles(selectedTile, selectedUnit.movement, selectedUnit); //remove move animation boxes
						Utils.removeMoveLines(shortestPath);//remove move lines as well as tile Movement animations 
						shortestPath = new Array(); //reset shortest path as we do not want this array to interfere with new paths to make
						
						doneMovement(); //go into doneMovement without doing the below
						
						canContinue = false; //We do not need to perform the defaults because they are already perform before doneMovement
					}
					else
					{
						selectedTile.removeUnit(); //remove unit from tile and place him in the mapContainer, overtop of the maptiles. This is needed because the unit graphic will always lie underneath the maptiles due to the fact that it is a child to only one maptile parent
						selectedUnit.x = selectedTile.x; 
						selectedUnit.y = selectedTile.y;
						mapContainer.addChild(selectedUnit);
					
						//Check for unit being trapped by other units in FOW
						for( i = shortestPath.length - 1; i>=0; i--)
						{
							if(shortestPath[i].hasUnit() && shortestPath[i].unit.player != turn) //if tile has unit which is not owned by the player whos turn it is
							{
								selectedSecondTile = shortestPath[i+1]; //sets the selectedSecondTile to the tile right before it was trapped
								Utils.removeMoveLines(shortestPath);//remove move lines as well as tile Movement animations early because the path will be edited
								shortestPath.splice(0, i+1); //creates a new shortestPath with the unit who attempted to move through another enemy unit
								i = -1; //end the check for units, we only need to find the first one
								hitEnemyUnit = true; //hitEnemyUnit is true because unit was trapped, will be resolved in doneMovement()
							}
						}
					
						selectedUnit.addMovementEventListener(); //the unit is now checking to see which movement animation direction to use.
						var tweenMove:Tween; //tween object for tweening movement
						//this loops runs through the shortestPath Array and tweens the motion from start to finish
						for(var g:int = shortestPath.length - 1; g>=1; g--)
						{
							if(g == 1) //if we're on the last tween tile, call the doneTween function once finished
							{
								if(shortestPath[g].xCord != shortestPath[g-1].xCord)
								{
									Tweener.addTween(selectedUnit, {x:shortestPath[g-1].x, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear", onComplete:doneMovement}); 
								}
								else if(shortestPath[g].yCord != shortestPath[g-1].yCord)
								{
									Tweener.addTween(selectedUnit, {y:shortestPath[g-1].y, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear", onComplete:doneMovement});
								}
							}
							else // else just do the tween
							{
								if(shortestPath[g].xCord != shortestPath[g-1].xCord)
								{
									Tweener.addTween(selectedUnit, {x:shortestPath[g-1].x, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear"}); 
								}
								else if(shortestPath[g].yCord != shortestPath[g-1].yCord)
								{
									Tweener.addTween(selectedUnit, {y:shortestPath[g-1].y, time:0.1, delay:(0.1 + ((0.1)*(((shortestPath.length-1)) - g))), transition:"linear"});
								}
							}
						}
					}
					
					if(canContinue) //Can continue defaults to true unless there's a unit on the same tile that the selected unit wants to go to, then this doens't run
					{
						Utils.removeMoveTiles(selectedTile, selectedUnit.movement, selectedUnit);
						Utils.removeMoveLines(shortestPath);//remove move lines as well as tile Movement animations 
						shortestPath = new Array(); //reset shortest path as we do not want this array to interfere with new paths to make
					}
					
					//All actions after this have been moved to the doneTween function, as they are all supposed to be done AFTER animation
				}
			}
			else if(isMenuUp) //if menu is up, This function dispatches the last button in the menu
			{
				if(e.keyCode == 13) //ENTER key pressed
				{
					popUpMenu.list[popUpMenu.list.length - 1].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				}
			}
		}
		
		//Handles button presses from menu based on button type, may possibly handle all buttons
		public function HandleButton(e:MouseEvent):void
		{
			if(e.target is infoButton) //info Button on any tile
			{
				/*if(infoWindow == null) //only display infoWindow if its not already up
				{
					trace("Info gets displayed");
					infoWindow = new InfoWindow(selectedSecondTile, txtFormat);
					infoWindow.closeButt.addEventListener(MouseEvent.MOUSE_DOWN, closeInfo, false, 0, true);
					infoWindow.x = 0;
					infoWindow.y = 0;
					stage.addChild(infoWindow);
					//selectedSecondTile = null; add this back in if problems come up
				
					//remove ability to interact with map until the info window is closed
					mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, dragMap);
					mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
					disableMapClicks = true;
				}*/
				e.target.performFunction(this, stage);
			}
			
			else if(e.target is doneButton) //Done button after movement (FINISHING BUTTON)
			{
				/*selectedUnit.finishTurn(); //finishes the selected unit's turn
				
				Utils.revealFog(selectedSecondTile, selectedUnit.vision, turn); //recalculate vision after unit is done moving
				
				if(waitingForAttack) //if we were waiting on attack choice, remove the attack animations and the waiting on attack state
				{
					waitingForAttack = false;
					Utils.removeAttackTiles(selectedSecondTile, selectedUnit.maxRange, selectedUnit);
				}
				
				//set selected stuff to null so that we can continue commanding other units
				clearSelectedData();
				
				//reenable map interaction now that movement with unit is done
				mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
				mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
				disableMapClicks = false;
				
				closePopUpMenu(); //closes pop up menu if its up
				
				closeInfoWindow(); //closes info window if its up
				
				finishButtonAvailable = false; //re-enable map control to the info screen since we are done moving the unit.
				*/
				e.target.performFunction(this, stage);
			}
			else if(e.target is cancelButton) //cancel current move and put unit back to original place (FINISHING BUTTON)
			{
				/*if(selectedBuilding == null) //if we're not working with a building (IE a unit, do this)
				{
					selectedSecondTile.removeUnit();
					selectedTile.addUnit(selectedUnit);
				
					if(waitingForAttack) //if we were waiting on attack choice, remove the attack animations and the waiting on attack state
					{
						waitingForAttack = false;
						Utils.removeAttackTiles(selectedSecondTile, selectedUnit.maxRange, selectedUnit);
					}
					//set selected stuff to null so that we can continue commanding other units
					clearSelectedData();
				
					//reenable map interaction now that movement with unit is done
					mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
					mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
					disableMapClicks = false;
				
					closePopUpMenu(); //closes pop up menu if its up
				
					closeInfoWindow(); //closes info window if its up
				
					finishButtonAvailable = false; //re-enable map control to the info screen since we are done moving the unit.
				}
				
				else //if we were waiting for a building, do this, reenable everything
				{
					Utils.removeAttackTiles(selectedSecondTile, selectedBuilding.maxRange, null, selectedBuilding);
					
					waitingForAttack = false;
					closePopUpMenu();
					clearSelectedData();
					disableMapClicks = false;
				}*/
				e.target.performFunction(this, stage);
			}
			else if(e.target is fireButton) //if it's the fire button (which comes from buildings who can attack)
			{
			/*
				selectedBuilding = selectedSecondTile.building; //set the selected building to the current one
				
				Utils.showAttackTiles(selectedSecondTile, selectedBuilding.maxRange, selectedBuilding.minRange, null, selectedBuilding); //show attack tiles for the building
				
				closePopUpMenu(); //close popup menu
				
				popUpMenu = new PopUpMenu();
				popUpMenu.list.push(new cancelButton()); //add a cancel button			
				
				popUpMenu.x = 1024; //Displays menu in bottom right corner.
				popUpMenu.y = stage.stageHeight - popUpMenu.height;
				stage.addChild(popUpMenu);
				popUpMenu.displayList();
				
				for(var l=0; l<popUpMenu.list.length; l++) //add listeners to the buttons in the menu
					
				{
					popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_UP, HandleButton, false, 0, true);
					popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OVER, mouseOverButton, false, 0, true);
					popUpMenu.list[l].addEventListener(MouseEvent.MOUSE_OUT, mouseOutButton, false, 0, true);
				}
				isMenuUp = true;
				
				waitingForAttack = true; //Now waiting for attack
				disableMapClicks = true; //cannot interact with map unit fireing is over;
				*/
				e.target.performFunction(this, stage);
			}
			else if(e.target is moveButton) //move button for units when they are on the same tile as a building when you select it
			{
				/*//run method to show movement tiles
				Utils.showMoveTiles(selectedTile, selectedUnit.movement, selectedUnit);
				waitingForMoveSelection = true;
				shortestPath.unshift(selectedTile); //add the current tile to selectedMoveTile, for keyboard movement
				
				closePopUpMenu(); //Closes popup menu if its up
				disableMapClicks = false; //re-enable map clicks to be able to move units*/
				e.target.performFunction(this, stage);
			}
			else if(e.target is constructButton) //if it's the construct button (The one where units build buildings)(FINISH BUTTON IF THE UNIT DOESN'T CANCEL THE CONSTRUCTION)
			{
				/*buildWindow = selectedUnit.initializeBuildWindow();
				
				if(buildWindow != null) //null checking first
				{
					//closePopUpMenu(); //closes pop up menu if its up
					hidePopUpMenu();
					
					buildWindow = selectedUnit.initializeBuildWindow();//take the build window from the unit selected
					
					for(var i:int = 0; i<buildWindow.buttonList.length; i++)
					{
						buildWindow.buttonList[i].addEventListener(MouseEvent.MOUSE_UP, buildEntity, false, 0, true);
					}
					var closeBut:closeButton = new closeButton();
					closeBut.x = 370;
					closeBut.y = 740;
					closeBut.addEventListener(MouseEvent.MOUSE_UP, closeBuildWindow, false, 0, true); //add a close button that closes the window
					buildWindow.addChild(closeBut);
					
					stage.addChild(buildWindow);
					
					//remove ability to interact with map until the Build window is closed
					mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, dragMap);
					mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
					disableMapClicks = true;
				}*/
				
				e.target.performFunction(this, stage);
			}
			else if(e.target is buildButton) //Build button to bring up a build menu. When finished the method that closes the build menu should set finishButtonAvailable to false
			{
				/*closePopUpMenu(); //closes pop up menu if its up
				
				buildWindow = selectedSecondTile.building.initializeBuildWindow(); //initialize build window and pass it to the main game
				
				for(var i:int = 0; i<buildWindow.buttonList.length; i++)
				{
					buildWindow.buttonList[i].addEventListener(MouseEvent.MOUSE_UP, buildEntity, false, 0, true);
				}
				var closeBut:closeButton = new closeButton();
				closeBut.x = 370;
				closeBut.y = 740;
				closeBut.addEventListener(MouseEvent.MOUSE_UP, closeBuildWindow, false, 0, true); //add a close button that closes the window
				buildWindow.addChild(closeBut);
				
				stage.addChild(buildWindow);
				
				//remove ability to interact with map until the Build window is closed
				mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, dragMap);
				mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
				disableMapClicks = true;*/
				
				e.target.performFunction(this, stage);
			}
			
			else if(e.target is resourceCollectorButton) //resource collector button constructs a resource collector at this current point
			{
				/*selectedSecondTile.addBuilding(new ResourceCollector()); //build resource collector here.
				selectedSecondTile.building.initializeBuilding(turn, selectedSecondTile); //Initialize it to the current players turn and location
			
				selectedUnit.finishTurn(); //builder finishes turn
				closePopUpMenu();
				
				disableMapClicks = false; //re-enable map clicks to be able to move units*/
				e.target.performFunction(this, stage);
			}
			
			else if(e.target is researchButton) //Research button brings up the research menu.
			{
				/*closePopUpMenu(); //closes pop up menu if its up
				
				researchWindow = new ResearchWindow(statusFormat);
				researchWindow.x = 0;
				researchWindow.y = 0;
				researchWindow.height = stage.stageHeight
				researchWindow.width = stage.stageWidth;
				stage.addChild(researchWindow); //add it to the stage
				
				//Add the research list from the current player to the research window
				researchWindow.addResearchList(turn.researchList);
				
				var closeBut:closeButton = new closeButton();
				closeBut.x = researchWindow.width - 150;
				closeBut.y = researchWindow.height - 150;
				closeBut.addEventListener(MouseEvent.MOUSE_UP, closeResearchWindow, false, 0, true); //add a close button that closes the window
				
				researchWindow.addChild(closeBut); //add a close button to the research window
				
				//remove ability to interact with map until the research window is closed
				mapContainer.removeEventListener(MouseEvent.MOUSE_DOWN, dragMap);
				mapContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
				disableMapClicks = true;*/
				e.target.performFunction(this, stage);
				
			}
			
			else if(e.target is endButton) //End turn button passes turn to the next player
			{
				/*clearSelectedData(); //sets everything selected to null incase we have any left over
				
				turn.renewTurn(); //renews the turn of all units which are currently owned by the player, as the turn is changing
				
				//player number is always 1 more than the position of the array
				if(turn.playerNumber == players.length) //if the player number equals the array length, we go back to the 0 index (IE player 1)
				{
					turn = players[0]; //player 1
				}
				else //else we advance the turn to the next player
				{
					turn = players[turn.playerNumber]; 
				}
				
				turn.giveIncome(selectedMap.planetList); //give income to the player whos turn it is, passes planet list to calculate resources as well
				
				statusWindow.updateInfo(turn, currentPlanet); //updates Status window doe new turn
				
				//if pop up menu or info window is up, close them and re-enable map control
				closePopUpMenu();
				if(infoWindow != null)
				{
					//re-enable map control
					mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
					mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
					disableMapClicks = false;
					closeInfoWindow();
				}

				Utils.calculateVision(map, turn); //recalculate vision for the new players turn
				trace("Player " + turn.playerNumber + "'s Turn");*/
				
				e.target.performFunction(this, stage);
			}
			
			else if(e.target is gotoPlanetButton) //Enters planet view
			{
				/*stage.removeChild(mapContainer) //remove the old map container
				mapContainer = new MapContainer //initialize a new one to be populated
				
				map = selectedSecondTile.planet.getMap(); //get the planet map
				currentPlanet = selectedSecondTile.planet; //set current planet to the planet we selected
				
				initializeMap(map, currentPlanet.getWidth(), currentPlanet.getHeight()); //initialize the map
				clearSelectedData(); //clear the current selection of data while we load a new map
				closePopUpMenu()*/
				e.target.performFunction(this, stage);
			}
			
			else if(e.target is exitPlanetButton) //exits Planet view
			{
				/*stage.removeChild(mapContainer) //remove the old map container
				mapContainer = new MapContainer() //initialize a new one to be populated
				
				map = selectedMap.map; //get the Game Map
				currentPlanet = null; //set current planet to the planet we selected
				
				initializeMap(map, selectedMap.getWidth(), selectedMap.getHeight()); //initialize the map
				clearSelectedData(); //clear the current selection of data while we load a new map
				closePopUpMenu()*/
				
				e.target.performFunction(this, stage);
			}
		}
		
		//closes info window
		public function closeInfo(e:MouseEvent):void
		{
			if(infoWindow != null)
			{
				infoWindow.removeEventListener(MouseEvent.MOUSE_DOWN, closeInfo);
				stage.removeChild(infoWindow);
				infoWindow = null;
				
				//re-enable interaction with map only if a finish button isn't available in the menu (IE, when you aren't moving a unit)
				mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
				mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
				if(!finishButtonAvailable)
				{
					disableMapClicks = false;
				}
			}
		}
		
		public function buildEntity(e:MouseEvent):void //build unit is called from a button in the build menu, it will contain the unit to be build (FINISHING BUTTON)
		{
			if(e.target is UnitButton)
			{
				if(turn.credits - e.target.unit.creditCost >= 0 && currentPlanet.getPlayerResources(turn.playerNumber) - e.target.unit.resourceCost >= 0) //if the player has enough credits and resources for the unit
				{
					selectedSecondTile.addUnit(e.target.unit); //the unit is contained within the button
					selectedSecondTile.unit.initializeUnit(turn); //initialize the unit to the player whos turn it currently is and on the tile the building is on
					selectedSecondTile.unit.finishTurn(); //When a unit is built, it doesnt have a turn that turn. So finish it before it starts
				
					turn.credits = turn.credits - e.target.unit.creditCost; //spend credits
					currentPlanet.removeResources(turn.playerNumber, e.target.unit.resourceCost);

					statusWindow.updateInfo(turn, currentPlanet) ////update status window with new credit amount
				
					if(buildWindow != null) // remove build window if its up
					{
						stage.removeChild(buildWindow);
						buildWindow = null;
					}
			
					selectedSecondTile.building.clearBuildWindow(); //we already have the build window saved, clear it from building memory
			
					//reenable map interaction now that the build window is closed
					mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
					mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
					disableMapClicks = false;
			
					Utils.revealFog(selectedSecondTile, selectedSecondTile.unit.vision, turn); //calculate vision on the newly built unit
					
					clearSelectedData();//clears selected data as it isn't needed anymore, mostly for safety
					
				}
			}
			else if(e.target is BuildingButton)
			{
				if(turn.credits - e.target.building.getCost(selectedSecondTile, turn) >= 0 && currentPlanet.getPlayerResources(turn.playerNumber) - e.target.building.resourceCost >= 0)
				{
					//construct building
					selectedSecondTile.addBuilding(e.target.building);
					selectedSecondTile.building.initializeBuilding(turn, selectedSecondTile); //Initialize it to the current players turn and location
					selectedSecondTile.building.hasFired = true; //can't fire on the turn it is made
					
					turn.credits = turn.credits - e.target.building.getCost(selectedSecondTile, turn); //spend credits
					currentPlanet.removeResources(turn.playerNumber, e.target.building.resourceCost);

					statusWindow.updateInfo(turn, currentPlanet) //updates credit amount
					
					if(buildWindow != null) // remove build window if its up
					{
						stage.removeChild(buildWindow);
						buildWindow = null;
					}
					
					
					selectedUnit.finishTurn();
					closePopUpMenu();
					
					//reenable map interaction now that the build window is closed
					mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
					mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
					disableMapClicks = false;
					finishButtonAvailable = false; //If a unit is constructing, it will now end his turn
					clearSelectedData(); //clears all selected data.
				}
			}
		}
		
		public function closeBuildWindow(e:MouseEvent):void
		{
			if(buildWindow != null) // remove build window if its up
			{
				stage.removeChild(buildWindow);
				buildWindow = null;
			}
			
			if(selectedSecondTile.hasBuilding())
			{
				selectedSecondTile.building.clearBuildWindow(); //we already have the build window saved, clear it from building memory
			}
			if(selectedSecondTile.hasUnit())
			{
				selectedSecondTile.unit.clearBuildWindow(); //clear the units build window if there's a unit
			}
			
			//reenable map interaction now that the build window is closed
			mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
			mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
			if(!finishButtonAvailable) //This will happen if a unit is building something. and the close button was clicked. the unit still has a turn technically
			{
				disableMapClicks = false;
			}
			
			showPopUpMenu(); //shows the popup menu as the close button was used
		}
		
		public function closeResearchWindow(e:MouseEvent):void
		{
			if(researchWindow != null) //remove research window if its up
			{
				stage.removeChild(researchWindow);
				researchWindow = null;
			}
			
			//reenable map interaction now that the research window is closed
			mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap);
			mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap);
			disableMapClicks = false;
		}
		
		//Map Handling functions below
		public function dragMap(e:MouseEvent):void
		{
			var bounds:Rectangle = new Rectangle(
				(mapContainer.width - (stage.stageWidth/2)) *(-1),
				(mapContainer.height - (stage.stageHeight/2)) * (-1),
				mapContainer.width,
				mapContainer.height
			);
			currentMouseX = mouseX;
			currentMouseY = mouseY;
			mapContainer.startDrag(false, bounds);
			
			if(!disableMapClicks) //only close the menu if disable map clicks isn't active (Mostly so that the menu stays up while we wait for important input, like finishing a units move
			{
				closePopUpMenu(); //closes popup menu if its up
			}

		}
		
		public	function dropMap(e:MouseEvent):void
		{
			mapContainer.stopDrag();
		}
		
		public function scaleMap(e:MouseEvent):void
		{
			if(e.delta > 0)
			{
				if(mapContainer.scaleX < 1)
				{
					mapContainer.scaleX = mapContainer.scaleX + 0.25;
					mapContainer.scaleY = mapContainer.scaleY + 0.25;
				}
			}
			else
			{
				if(mapContainer.scaleX > 0.25)
				{
					mapContainer.scaleX = mapContainer.scaleX - 0.25;
					mapContainer.scaleY = mapContainer.scaleY - 0.25;
				}
			}
		}
		
		public function moveMap(xCord:int, yCord:int):void //this function moves the camera (or map) into the position you tell it. Whatever coordinates are given will be attempted to be placed at the center of the screen
		{
			trace("Moving camera to unit Location: " + xCord + "," + yCord);
			mapContainer.x = (512 - xCord);
			mapContainer.y = (384 - yCord);
		}
		
		public function closePopUpMenu():void //removes pop up menu if its up, clearing it's contents
		{
			if(isMenuUp)
			{
				stage.removeChild(popUpMenu);
				isMenuUp = false;
			}
		}
		
		public function hidePopUpMenu():void //hides pop up menu, keeping it's contents
		{
			if(isMenuUp)
			{
				popUpMenu.visible = false;
			}
		}
		
		public function showPopUpMenu():void //shows pop up menu, used after hide
		{
			if(isMenuUp)
			{
				popUpMenu.visible = true;
			}
		}
		
		public function closeInfoWindow():void //remove info window if its up
		{
			if(infoWindow != null)
			{
				infoWindow.removeEventListener(MouseEvent.MOUSE_DOWN, closeInfo);
				stage.removeChild(infoWindow);
				infoWindow = null;
				
			}
		}
		
		public function updateQuickInfo(e:MouseEvent)
		{
			if(e.currentTarget is MapTile)
			{
				quickInfoWindow.updateInfo(e.currentTarget as MapTile);
			}
		}
		
		public function clearSelectedData():void //This clears all selected tiles and units, usually done at the end of a units turn
		{
			selectedTile = null;
			selectedUnit = null;
			selectedSecondTile = null;
			selectedBuilding = null;
			unitMoved = false;
		}
		
		public function mouseOverButton(e:MouseEvent):void //updates the button info window to contain the information about the button hovered over
		{
			if(!buttonInfoWindow.visible) //if the button info window is not already visible. Make it visible
			{
				buttonInfoWindow.visible = true;
				stage.addChild(buttonInfoWindow);
			}
			
			if(e.currentTarget is GameButton) //if the current target is a game button, perform update
			{
				buttonInfoWindow.updateInfo(e.currentTarget as GameButton);
			}
		}
		
		public function mouseOutButton(e:MouseEvent):void //removes the button info window
		{
			if(buttonInfoWindow.visible) //if button info window is visible. make it invisible and remove it from the stage
			{
				buttonInfoWindow.visible = false;
				stage.removeChild(buttonInfoWindow);
			}
			
			buttonInfoWindow.clearInfo();
		}
		
		public function addMapListeners():void //adds listeners for map control
		{
			mapContainer.addEventListener(MouseEvent.MOUSE_DOWN, dragMap, false, 0, true);
			mapContainer.addEventListener(MouseEvent.MOUSE_UP, dropMap, false, 0, true);
			mapContainer.addEventListener(MouseEvent.MOUSE_WHEEL, scaleMap, false, 0, true);
		}
	}
}