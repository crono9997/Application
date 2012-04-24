package  com.superjai.connect4
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * Game Logic controls all gameplay.
	 * @author Jeremy Weeks
	 */
	public class GameLogic extends Sprite
	{
		public var tileArray:Array = [];
		public var quitButton:QuitButton = new QuitButton();
		public var retry:Boolean = false;		
		public var boardProperties:Object = {
			tileWidth: 64,
			tileHeight: 64,
			colCount: 7,
			rowCount: 6
		};		
		private var board:Sprite = new Sprite();
		private var boardCover:Sprite = new Sprite();
		private var tileContainer:Sprite = new Sprite();		
		private var glowTile:Tile;		
		private var colors:Array = [0x900000, 0x333333];
		private var curColor:int = 1;		
		private var ready:Boolean = false;		
		private var glowArray:Array = [];
		private var playerTurn:Boolean = true;
		private var aiDelay:int = 0;
		private var winLose:WinLoseMenu;
		private var main:Main;
		private var aiPlayer:AiPlayer;
		
		public function GameLogic(_main:Main, settings:Object):void {
			main = _main;
			boardProperties.colCount = settings.cols;
			boardProperties.rowCount = settings.rows;
			colors[0] = settings.playerColor;
			colors[1] = settings.cpuColor;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		/**
		* Sets position, builds board, adds AI and adds events. Will not run until stage property is not null.
		* @param e Event ADDED_TO_STAGE dispatched once stage is not null.
		*/
		public function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			buildBoard();
			boardCover.alpha = 0;
			
			aiPlayer = new AiPlayer(this, colors);
			
			for (var j:int = 0; j < boardProperties.rowCount; j++) {
				var arr:Array = [];
				for (var i:int = 0; i < boardProperties.colCount; i++) arr.push(null);
				tileArray.push(arr);
			}
			
			addChild(quitButton);
			
			board.addChild(tileContainer);
			board.addChild(boardCover);
			
			addChild(board);
			glowTile = new Tile(boardProperties.tileWidth, boardProperties.tileHeight, 0, 0, 0x00ff00, this, 0, true);
			
			addEventListener(Event.ENTER_FRAME, enterFrameBoard, false, 0, true);
		}
		
		/**
		* Builds the board based on tilesize in board properties.
		* 
		*/
		private function buildBoard():void {
			var lineSize:int = 3;
			if (boardProperties.tileWidth < 38)lineSize = 1;
			else if (boardProperties.tileWidth < 68) lineSize = 2;
			
			boardCover.graphics.clear();
			boardCover.graphics.lineStyle(lineSize, 0x222222);
			boardCover.graphics.beginFill(0x999999);
			boardCover.graphics.drawRect(0, 0, (boardProperties.colCount * boardProperties.tileWidth), (boardProperties.rowCount * boardProperties.tileHeight));
			for (var j:int = 0; j < boardProperties.rowCount; j++) {
				boardCover.graphics.moveTo(0, j*boardProperties.tileHeight);
				boardCover.graphics.lineTo((boardProperties.colCount * boardProperties.tileWidth), j*boardProperties.tileHeight);
				for (var i:int = 0; i < boardProperties.colCount; i++) {
					boardCover.graphics.drawCircle(i*boardProperties.tileWidth+boardProperties.tileWidth/2, j*boardProperties.tileHeight+boardProperties.tileHeight/2, boardProperties.tileWidth/2.2);
					boardCover.graphics.moveTo(i*boardProperties.tileWidth, 0);
					boardCover.graphics.lineTo(i*boardProperties.tileWidth, (boardProperties.rowCount * boardProperties.tileHeight));
				}
			}
			boardCover.graphics.endFill();
		}
		
		/**
		* Fades board in and starts game.
		* @param e Event enterframe dispatched each frame.
		*/
		private function enterFrameBoard(e:Event):void {
			boardCover.alpha += (1 - boardCover.alpha) * 0.2;
			if (boardCover.alpha >= 0.98) {
				boardCover.alpha = 1; 
				startGame();
				removeEventListener(Event.ENTER_FRAME, enterFrameBoard);
			}
		}
		
		/**
		* Fades board out and kills game.
		* @param e Event enterframe dispatched each frame.
		*/
		private function exitFrameBoard(e:Event):void {
			if (tileContainer.numChildren <= 0) {
				removeEventListener(Event.ENTER_FRAME, update);			
				boardCover.alpha += (0 - boardCover.alpha) * 0.2;
				quitButton.alpha += (0 - quitButton.alpha) * 0.2;
				if (boardCover.alpha <= 0.02) {
					boardCover.visible = false; 
					quitButton.visible = false; 
					removeEventListener(Event.ENTER_FRAME, exitFrameBoard);
					oKill();
				}				
			}
		}
		
		/**
		* Upopn quitButton being clicked, quits game.
		* @param e MouseEvent dispatched.
		*/
		public function onQuit(e:MouseEvent):void {
			ready = false;
			for (var i:int = 0; i < tileContainer.numChildren; i++) {
				var tile:Tile = tileContainer.getChildAt(i) as Tile;
				tile.dieNow();
			}
			if (winLose) {
				winLose.play();
				winLose.continuePlay = true;
			}
			quitButton.removeEventListener(MouseEvent.CLICK, onQuit);
			stage.removeEventListener(MouseEvent.CLICK, oClick);
			addEventListener(Event.ENTER_FRAME, exitFrameBoard, false, 0, true);
		}
		
		/**
		* Quits game, tells main to load main menu or reload gamelogic and removes itself from stage.
		* 
		*/
		private function oKill():void {
			main.reloadMainMenu(retry);
			main.removeChild(this);
		}
		
		/**
		* Initializes game properties and gives control to player.
		* 
		*/
		public function startGame():void{			
			glowTile.x = -100;
			glowTile.y = boardProperties.tileHeight * -1;
			glowTile.alpha = 0.3;
			addChild(glowTile);			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);			
			stage.addEventListener(MouseEvent.CLICK, oClick, false, 0, true);
			quitButton.addEventListener(MouseEvent.CLICK, onQuit, false, 0, true);
			oResize();
			checkWin(0);				
			if (Math.random() < 0.4) {
				playerTurn = false;
				aiDelay = 2;
				curColor = 1;			
			}
			ready = true;
		}
		
		/**
		* Resizes board, tiles and quit button when stage is resized..
		* 
		*/
		public function oResize():void {
			var size:int = (stage.stageWidth-50) / boardProperties.colCount;
			if ((stage.stageHeight-150) / boardProperties.rowCount < size) size = (stage.stageHeight-150) / boardProperties.rowCount;
			boardProperties.tileWidth = size;
			boardProperties.tileHeight = size;
			buildBoard();
			for (var i:int = 0; i < tileContainer.numChildren; i++) 
			{
				var tile:Tile = tileContainer.getChildAt(i) as Tile;
				tile.redraw();
			}
			glowTile.redraw();
			board.x = (stage.stageWidth-(boardProperties.colCount*boardProperties.tileWidth))/2;
			board.y = 75;			
			if (winLose) winLose.oResize();			
			quitButton.x = stage.stageWidth - 66;
			quitButton.y = board.y+boardProperties.rowCount*size+40;			
			update(null);
		}
		
		/**
		* Checks win condition of matching 4 in a row. If not check if board full form Draw.
		* @param color Color of last tile dropped to be checked for victory.
		*/
		public function checkWin(color:uint):void {			
			ready = true;
			for (var k:int = 0; k < boardProperties.colCount; k++) glowArray[k] = -1;
			for (var j:int = 0; j < boardProperties.rowCount; j++) {				
				for (var i:int = 0; i < boardProperties.colCount; i++) {
					if (tileArray[j][i]) {
						if(tileArray[j][i].color == color) {		
							checkRow(i, j, 0, 1, color);
							checkRow(i, j, 1, 0, color);
							checkRow(i, j, 1, 1, color);
							checkRow(i, j, 1, -1, color);
						}
					}else {
						if (j > glowArray[i]) glowArray[i] = j;
					}
				}
			}			
			
			curColor++;
			if (curColor > 1) curColor = 0;
			glowTile.color = colors[curColor];
			glowTile.redraw();
			
			if (curColor == 0) playerTurn = true;
			else {
				playerTurn = false;
				aiDelay = 24;
			}			
			
			if (!winLose) {
				var full:Boolean = true;
				for (var l:int = 0; l < tileArray[0].length; l++) {
					if (!tileArray[0][l]) {
						full = false;
						break;
					}
				}
				if (full) {
					ready = false;
					winLose = new WinLoseMenu(this, true, true);	
					addChild(winLose);
				}
			}
		}
		
		/**
		* Checks position and direction for 4 matching tiles. If 4 in a row, adds winLoseMenu and removes control form player.
		* @param i Column position
		* @param j Row position
		* @param dx X change (-1,0,1)
		* @param dy Y change (-1,0,1)
		* @param color Color to match.
		*/
		public function checkRow(i, j, dx, dy, color):void {
			var hitsLint = 1;
			var bool:Boolean = true;
			var k:int = 1;
			for (k = 1; k < 4; k++) {
				if (!checkMatch(i+dx*k, j + dy*k, color)) {
					bool = false;
					break;
				}
			}
			if (bool) {
				for (k = 0; k < 4; k++) {
					tileArray[j + dy * k][i + dx * k].highLight.visible = true;
				}
				ready = false;
				winLose = new WinLoseMenu(this, color == colors[0]);
				if (color == colors[0]) main.scoreBoard.updateScore(1, 0);
				else main.scoreBoard.updateScore(0, 1);
				
				for (var l:int = 0; l < tileContainer.numChildren; l++) {
					var tile:Tile = tileContainer.getChildAt(l) as Tile;
					tile.controlFace(0, 0, curColor, 300);
				}
				
				addChild(winLose);
			}
		}		
		
		/**
		* Checks a position on the board to see if it has a tile and if the tile matches a given color.
		* @param i column to check.
		* @param j row to check.
		* @param color color to check.
		* @return Boolean tile matches color.
		*/
		public function checkMatch(i, j, color):Boolean {
			if (j >= boardProperties.rowCount|| j<0) return false;
			if (tileArray[j][i] && color == tileArray[j][i].color) {
				return true;
			}else return false;
		}
		
		/**
		* Upon player click, if their turn and click is triggered in valid position, adds tile.
		* @return e MouseEvent dispatched.
		*/
		private function oClick(e:MouseEvent):void {
			if (playerTurn && ready && mouseX > board.x && mouseX < board.x + boardProperties.colCount * boardProperties.tileWidth &&
			mouseY > board.y && mouseY < board.y + boardProperties.rowCount * boardProperties.tileHeight) {
				var pos:int = Math.ceil((mouseX - board.x) / boardProperties.tileWidth) - 1;
				if (!tileArray[0][pos])
					addTile(pos);
			}			
		}
		
		/**
		* Runs each frame while gameLogic is running. Updates tiles, glowTile position and handles ai timing and tile choice.
		* @param e Event enterframe dispatched each frame.
		*/
		private function update(e:Event):void {
			for (var i:int = 0; i < tileContainer.numChildren; i++) {
				var tile:Tile = tileContainer.getChildAt(i) as Tile;
				tile.update();
			}
			if(playerTurn){
				if (ready && mouseX > board.x && mouseX < board.x + boardProperties.colCount * boardProperties.tileWidth &&
				mouseY > board.y && mouseY < board.y + boardProperties.rowCount * boardProperties.tileHeight) {
					var pos:int = Math.ceil((mouseX - board.x) / boardProperties.tileWidth) - 1;
					if (!tileArray[0][pos]){
						glowTile.x = board.x+pos * boardProperties.tileWidth;
						glowTile.y = board.y+glowArray[pos] * boardProperties.tileHeight;
						glowTile.visible = true;
					}else
						glowTile.visible = false;
				}else {
					glowTile.visible = false;
				}
			}else {
				glowTile.visible = false;
				if (ready){
					aiDelay--;
					if (aiDelay <= 0) {
						addTile(aiPlayer.choose());
					}
				}
			}
		}
		
		/**
		* Adds a tile at the given column.
		* @param _col Column to add a tile at.
		*/
		public function addTile(_col:int):void {							
			var tile:Tile = new Tile(boardProperties.tileWidth, boardProperties.tileHeight, 0, _col, colors[curColor], this, curColor);
			tileContainer.addChild(tile);	
			ready = false;	
			
		}
		
		/**
		* Have tiles near dropped tile react to dropped tile.
		* @param _col Column of dropped tile.
		* @param _row Row of dropped tile.
		*/
		public function tileReaction(_col:int, _row:int):void {
			for (var i:int = _col-1; i < _col+2; i++)
				for (var j:int = _row - 1; j< _row +2; j++)
					if (j >= 0 && j < tileArray.length && i >= 0 && i < tileArray[j].length &&!(j==_row && i ==_col))
						if (tileArray[j][i])
							tileArray[j][i].controlFace(_col - i, _row - j, curColor, 100);						
		}
	}	
}