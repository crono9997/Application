package  com.superjai.connect4
{
	/**
	 * AI Player can make a choice as where to put a tile.
	 * @author Jeremy Weeks
	 */
	public class AiPlayer
	{
		private var gameLogic:GameLogic;
		private var colors:Array;
		private var aiColor:uint;
		private var playerColor:uint;
		
		public function AiPlayer(_gameLogic:GameLogic, _colors:Array):void {
			gameLogic = _gameLogic;
			colors = _colors;
			playerColor = _colors[0];
			aiColor = _colors[1];
		}		
			
		/**
		* Checks the board for possible moves and makes a choice based on tile positions.
		* @return int column to place tile..
		*/
		public function choose():int {
			var selection:int = -1;
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var l:int = 0;
			var positions:Array = [
				{dx:1, dy:1, dx2:-1, dy2:-1}, 
				{dx:0, dy:1, dx2:0, dy2:-1}, 
				{dx:-1, dy:1, dx2:1, dy2:-1}, 
				{dx:-1, dy:0, dx2:1, dy2:0}] ; 
			var choices:Array = [];
			var count:int = 1;
			var bool:Boolean = true;
			var curRow:int = 0;
			for (i = 0; i < gameLogic.boardProperties.colCount; i++) {
				//Determine if column is not full
				if (!gameLogic.tileArray[0][i]) {
					curRow = 0;
					//Determine the lowest open row of the current column
					for (j = 1; j < gameLogic.boardProperties.rowCount; j++) {
						if (!gameLogic.tileArray[j][i]) {
							curRow = j;
						}
					}
					j = curRow;	
					count = 1;
					bool = true;
					for (k = 0; k < positions.length; k++) {
						bool = true;
						count = 1;
						//Determine how many tiles connect after tile
						for (l = 1; l < 4; l++) {
							if (!checkMatch(i + positions[k].dx * l, j + positions[k].dy * l, aiColor)) {
								bool = false;
								break;
							}else {
								count++;
							}
						}
						if (!bool){
							//Determine how many tiles connect before tile
							for (l = 1; l < 4; l++) {
								if (!checkMatch(i + positions[k].dx2 * l, j + positions[k].dy2 * l, aiColor)) {
									choices.push( { count:count, i:i} );
									bool = false;
									break;
								}else {
									count++;
								}
							}
						}
						//If count 4 or more win
						if (count>=4) {
							trace("WIN "+i + ": " + curRow);
							selection = i;
							return selection;
							break;
						}
					}
				}
			}
			for (i = 0; i < gameLogic.boardProperties.colCount; i++) {
				//Determine if column is not full
				if (!gameLogic.tileArray[0][i]) {
					curRow = 0;
					//Determine the lowest open row of the current column
					for (j = 1; j < gameLogic.boardProperties.rowCount; j++) {
						if (!gameLogic.tileArray[j][i]) {
							curRow = j;
						}
					}
					j = curRow;	
					count = 1;
					bool = true;
					var front:Boolean = false;
					var back:Boolean = false;
					var row:int;
					var col:int;
					var count2:int;
					//Determine the given position would block player from winning
					for (k = 0; k < positions.length; k++) {
						bool = true;
						count = 1;
						front = false;
						back = false;
						//(player) Determine how many tiles connect after tile.						
						for (l = 1; l < 4; l++) {
							if (!checkMatch(i + positions[k].dx * l, j + positions[k].dy * l, playerColor)) {
								row = j + positions[k].dy * l;
								col = i + positions[k].dx * l;
								bool = false;
								front = checkMatch(i + positions[k].dx * l, j + positions[k].dy * l, aiColor);
								if (row >= gameLogic.boardProperties.rowCount || row < 0 || col >= gameLogic.boardProperties.colCount || col < 0) {
									front = true;
								}else if(row+1 < gameLogic.boardProperties.rowCount){
									if (!gameLogic.tileArray[row + 1][i + positions[k].dx * l]) {
										front = true;
									}											
								}
								if (j + positions[k].dy * l >= gameLogic.boardProperties.rowCount|| j + positions[k].dy * l<0) front = true;
								break;
							}else count++;							
						}
						if(!bool){
							//(player) Determine how many tiles connect before tile.
							for (l = 1; l < 4; l++) {
								if (!checkMatch(i + positions[k].dx2 * l, j + positions[k].dy2 * l, playerColor)) {
									row = j + positions[k].dy2 * l;
									col = i + positions[k].dx2 * l;
									bool = false;
									back = checkMatch(i + positions[k].dx2 * l, j + positions[k].dy2 * l, aiColor);
									if (row >= gameLogic.boardProperties.rowCount || row < 0 || col >= gameLogic.boardProperties.colCount || col < 0) {
										back = true;
									}else if(row+1 < gameLogic.boardProperties.rowCount){
										if (!gameLogic.tileArray[row + 1][i + positions[k].dx2 * l]) {
											back = true;
										}											
									}											
									break;
								}else {
									count++;
								}
							}
						}
						//If count 4 or more block, if count = 3 and positions on both ends are open and available block.
						if (count>=4) {
							trace("BLOCK "+i + ": " + curRow);
							selection = i;
							return selection;
							break;
						}else if (count == 3 && (!front && !back)) {
							trace("2 WAY BLOCK "+i + ": " + curRow);
							selection = i;
							return selection;
							break;
						}
					}
				}
			}
			choices.sortOn("count", Array.NUMERIC | Array.DESCENDING);
			for (i = 0; i < choices.length; i++) {
				if (choices[i].count != choices[0].count) {
					choices.splice(i, choices.length);
					break;
				}
			}
			selection = choices[randomNumber(0, choices.length-1)].i;
			
			return selection;
		}
		
		/**
		* Checks a position on the board to see if it has a tile and if the tile matches a given color.
		* @param i column to check.
		* @param j row to check.
		* @param color color to check.
		* @return Boolean tile matches color.
		*/
		public function checkMatch(i, j, color):Boolean {
			if (j >= gameLogic.boardProperties.rowCount|| j<0) return false;
			if (gameLogic.tileArray[j][i] && color == gameLogic.tileArray[j][i].color) {
				return true;
			}else return false;
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