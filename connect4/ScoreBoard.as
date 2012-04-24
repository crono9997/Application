package  com.superjai.connect4
{
	import flash.display.MovieClip;
	
	/**
	 * Displays wins and losses.
	 * @author Jeremy Weeks
	 */
	public class ScoreBoard extends MovieClip{
		
		var wins:int = 0;
		var losses:int = 0;
		//Contains winsTf:Textfield and lossesTf:Textfield in ide. 
		public function ScoreBoard():void {
			updateScore(0,0);
		}
		
		/**
		* Updates the wins and losses textfields.
		* @param w int to increase wins.
		* @param l int to increase losses.
		*/
		public function updateScore(w:int, l:int):void {
			wins += w;
			losses += l;
			winsTf.text = wins.toString();
			lossesTf.text = losses.toString();
		}
	}	
}