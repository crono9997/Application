package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * The menu screen displayed after the game has been won/lost.
	 * @author Jeremy Weeks
	 */
	public class WinLoseMenu extends MovieClip
	{
		private var win:Boolean;
		private var gameLogic:GameLogic;
		public var continuePlay:Boolean = false;
		
		public function WinLoseMenu(_gameLogic:GameLogic, _win:Boolean, _tie:Boolean = false ):void {
			gameLogic = _gameLogic;
			win = _win;
			if(_tie) tf.tf.text = "Draw"; // If _tie sets tie message, default message is winning.
			else if (!win) tf.tf.text = "You Lose"; // If !win sets lose message, default message is winning.
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		/**
		* Sets position and adds events. Will not run until stage property is not null.
		* @param e Event ADDED_TO_STAGE dispatched once stage is not null.
		*/
		public function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			oResize();
			retryButton.addEventListener(MouseEvent.CLICK, oRetry, false, 0, true);
		}
		
		/**
		* Upon rety button being clicked, Gamelogic class triggered to restart game.
		* @param e MouseEvent dispatched.
		*/
		private function oRetry(e:MouseEvent):void {
			gameLogic.retry = true;
			gameLogic.onQuit(null);
			play();
		}
		
		/**
		* Resizes menu to center position upon initialization or stage size changing.
		*/
		public function oResize():void {
			x = stage.stageWidth / 2;
			y = (gameLogic.quitButton.y + 30) / 2;			
		}
	}	
}