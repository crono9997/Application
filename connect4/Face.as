package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Controls the face of the game tile.
	 * @author Jeremy Weeks
	 */
	public class Face extends MovieClip
	{
		public var row:int = 0;
		public var col:int = 0;
		private var moveTo:Point = new Point();
		private var eye1:Eye;
		private var eye2:Eye;
		private var delay:int = 0;
		private var blinkDelay:int = 0;
		private var mouth:Mouth = new Mouth();
		private var tile:Tile;
		private var gameLogic:GameLogic;
		private var homePosition:Point;
		private var playerType:int;
		private var speed:Number = 0.4;
		private var emotions:Array = [
			{ name: "Happy", lidDis: 35, lidRot: 0 },
			{ name: "Mad", lidDis: 5, lidRot: 15 },
			{ name: "Sad", lidDis: 25, lidRot: -10 },
			{ name: "High", lidDis: 5, lidRot: 0 }
		];
		
		public function Face(_tile:Tile, _gameLogic:GameLogic, _x:int, _y:int, _row:int, _col:int, _scale:Number, _playerType:int ):void {
			eye1 = eyea; //Assign eye1 to the left eye in the ide - eyea
			eye2 = eyeb; //Assign eye1 to the Right eye in the ide - eyea
			eye2.clone = true;			
			mouth = mouth1; //Assign mouth to the mouth1 object in the ide
			gameLogic = _gameLogic;
			tile = _tile;
			x = _x;
			y = _y;
			row = _row;
			col = _col;
			scaleX = _scale;
			scaleY = _scale;
			playerType = _playerType;
			homePosition = new Point(x, y);
			speed = randomNumber(2, 5) / 10;
			eye1.speed = speed;
			eye2.speed = speed;
		}
		
		/**
		* Runs every frame to update the face. If eyes and mouth are ready pick new position.
		* 
		*/
		public function update():void {
			if (!eye1.ready) {
				eye1.update();
				eye2.update();
				x  += ((homePosition.x+moveTo.x*(25*scaleX)) - x) * speed;	
				y  += ((homePosition.y+moveTo.y*(25*scaleX)) - y) * speed;
			}
			if (delay > 0) {
				blinkDelay--;
				if (eye1.ready && blinkDelay <=0) {
					eye1.blink();
					eye2.blink();
					blinkDelay = randomNumber(96, 156);
					return;
				}
				delay--;
				return;
			}
			if (eye1.ready) {
				if(mouth.ready)	pickPosition();	
				else mouth.play();							
			}
		}
			
		/**
		* Picks position of eye pupils.
		* 
		*/		
		public function pickPosition():void {
			var origMoveTo:Point = moveTo.clone(); //Sets previous pupil position to avoid triggering the same position twice in a row
			moveTo = new Point(randomNumber( -1, 1) , randomNumber( -1, 1));
			var i:int = row+moveTo.y;
			var j:int = col  + moveTo.x;
			while(i< 0 || j<0 || i>=gameLogic.tileArray.length || j>=gameLogic.tileArray[i].length || (origMoveTo.x==moveTo.x && origMoveTo.y==moveTo.y)){
				moveTo = new Point(randomNumber( -1, 1) , randomNumber( -1, 1));
				i = row+moveTo.y;
				j = col  + moveTo.x;
			}
			delay = randomNumber(20, 210);
			if (false && randomNumber(0, 5) == 0) {
				eye1.followMouse(0);
				eye2.followMouse(0);
			}else{				
				eye1.pickPosition(moveTo);
				eye2.pickPosition(new Point(moveTo.x * -1, moveTo.y));				
				pickEmotion();
			}
		}	
		
		/**
		* Pick emotion of eye lids and mouth. 
		* 
		*/		
		private function pickEmotion():void {
			var i:int = randomNumber(0, emotions.length - 1);
			i = row+moveTo.y;
			var j:int = col  + moveTo.x;
			var arr:Array = gameLogic.tileArray;
			if (moveTo.x == 0 && moveTo.y == 0)
				i = playerType;
			else if (gameLogic.tileArray[i] && gameLogic.tileArray[i][j]){
				if(gameLogic.tileArray[i][j].color == tile.color) {
					i = 0;
				}else {
					i = 1;
				}
			}else{
				i = 2;
				delay = randomNumber(20, 60);
			}
			eye1.setEmotion(emotions[i].lidDis, emotions[i].lidRot);
			eye2.setEmotion(emotions[i].lidDis, emotions[i].lidRot * -1);
			
			mouth.gotoAndPlay(emotions[i].name);
			mouth.ready = false;			
		}
		
		/**
		* Sets position of eye pupils. If p is null chooses random position
		* @param p Point determining where to move the pupils.
		*/		
		public function setEmotion(i:int):void {
			if (playerType == i) i = 0;
			else i = 1;
			eye1.setEmotion(emotions[i].lidDis, emotions[i].lidRot);
			eye2.setEmotion(emotions[i].lidDis, emotions[i].lidRot * -1);
			
			mouth.gotoAndPlay(emotions[i].name);
			mouth.ready = false;			
		}
		
		/**
		* Sets position of eye lids and mouth. 
		* @param _moveTo Point determining where to move the pupils.
		* @param _delay int number of frames to hold position.
		*/		
		public function setPosition(_moveTo:Point, _delay:int):void {
			moveTo = _moveTo;
			eye1.pickPosition(moveTo);
			eye2.pickPosition(new Point(moveTo.x * -1, moveTo.y));	
			delay = _delay;
		}
		
		
		/**
		* Generates random int between low and high. 
		* @param low Int of lowest random number.
		* @param high Int of highest random number.
		* @return int random int.
		*/	
		private function randomNumber(low:int, high:int):int{
			if (low >= high) low = 0;
			return Math.floor(Math.random() * (1+high-low)) + low; 
		}		
	}	
}