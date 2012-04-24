package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * The game tile used to make connections of four. Contains a face that responds to nearby tiles.
	 * @author Jeremy Weeks
	 */
	public class Tile extends MovieClip
	{
		public var color:uint = 0;		
		public var highLight:Sprite = new Sprite();
		private var w:int = 1;
		private var h:int = 1;
		private var row:int = 0;
		private var col:int = 0;
		private var alive:Boolean = true;
		private var fallingInit:Boolean = false;
		private var falling:Boolean = false;
		private var fallSpd:int = 0;
		private var yDest:int = 0;	
		private var face:Face;
		private var die:Boolean = false;
		private var gameLogic:GameLogic;
		private var playerType:int;
		
		public function Tile(_w:int, _h:int, _r:int, _c:int, _color:uint, _gameLogic:GameLogic, _playerType:int = 0, fake:Boolean = false):void {
			row = _r;
			col = _c;
			w = _w;
			h = _h;
			x = w * col;
			y = h * -1;
			color = _color;
			playerType = _playerType;
			gameLogic = _gameLogic;			
			highLight.visible = false;
			addChild(highLight);			
			draw();			
			if(!fake)startFalling();
		}
		
		/**
		* Runs every frame to update the face and fall position.
		* 
		*/
		public function update():void {
			face.update();
			if (falling) fall();
		}
		
		/**
		* Draws the graphics for the tile and adds the face.
		* 
		*/
		private function draw():void {
			var lineSize:int = 3;
			if (w < 38)lineSize = 1;
			else if (w < 68) lineSize = 2;
			
			graphics.clear();
			graphics.lineStyle(lineSize, 0);
			graphics.beginFill(color, 1);
			graphics.drawCircle(w / 2, h / 2, w / 2);
			graphics.endFill();
			graphics.beginFill(0, 0.4);
			graphics.drawCircle(w / 2, h / 2, w / 2);
			graphics.drawCircle(w / 2, h / 2, w / 2.7);
			graphics.endFill();
			
			highLight.graphics.clear();
			highLight.graphics.lineStyle(lineSize, 0);
			highLight.graphics.beginFill(0x3333ff, 1);
			highLight.graphics.drawCircle(w / 2, h / 2, w / 2);
			highLight.graphics.drawCircle(w / 2, h / 2, w / 2.7);
			highLight.graphics.endFill();
			
			var scale:Number = (w / 2) / 320;
			if (face && contains(face)) removeChild(face);
			face = new Face(this, gameLogic, w / 2, h / 2, row, col, scale, playerType);
			addChild(face);
		}
		
		/**
		* Sets pupil position and emothion for face
		* @param _x int to move pupil.x.
		* @param _y int to move pupil.y.
		* @param emo int index of emotion to select.
		* @param _delay int number of frames to maintain position and emotion.
		*/
		public function controlFace(_x:int, _y:int, emo:int, _delay:int):void {
			face.setEmotion(emo);
			face.setPosition(new Point(_x, _y), _delay);
		}
		
		/**
		* Triggers a redrawing of the graphics based on the tileSize of gamelogic.
		* 
		*/
		public function redraw():void{
			w = gameLogic.boardProperties.tileWidth;
			h = gameLogic.boardProperties.tileHeight;
			draw();
			x =gameLogic.boardProperties.tileWidth*col;
			y = gameLogic.boardProperties.tileHeight*row;
		}
		
		/**
		* Initializes the falling parameters and finds the lowest empty row in the current column.
		* 
		*/
		public function startFalling():void {
			falling = true;
			fallSpd = 10;
			yDest = 0;
			for (var i:int = row + 1; i < gameLogic.boardProperties.rowCount; i++) {
				if (!gameLogic.tileArray[i][col]) {
					row++;
					yDest = (row) * (gameLogic.boardProperties.tileHeight);	
					face.row = row;
				}
			}
			gameLogic.tileReaction(col, row);
			gameLogic.tileArray[row][col] = this;			
		}
		
		/**
		* Initializes the dieing process and starts falling.
		* 
		*/
		public function dieNow():void {
			falling = true;
			fallSpd = 10;
			die = true;
		}
		
		/**
		* Moves the tile at its current fallspeed, increase fallspeed each frame and checks winCondition upon reaching destination.
		* 
		*/
		private function fall():void {			
			if (die) {
				if (y > stage.stageHeight + 100) {
					gameLogic.tileArray[row][col] = null;
					falling = false;
					parent.removeChild(this);
					return;
				}
				yDest = y + 500;
			}	
			y += fallSpd;
			fallSpd+=5;
			if (y > yDest) {
				y = yDest;	
				falling = false;
				gameLogic.checkWin(color); 
			}
		}
	}	
}