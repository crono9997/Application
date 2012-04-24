package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * Main menu, contains play button to start gameLogic.
	 * @author Jeremy Weeks
	 */
	public class MainMenu extends MovieClip
	{
		private var phase:int = 0;
		private var main:Main;
		
		public function MainMenu(_main:Main):void 
		{
			main = _main;		
			playButton.addEventListener(MouseEvent.CLICK, oPlay, false, 0, true);
		}
		
		/**
		* Play button clicked. Plays animations to fade out menu.
		* @param e MouseEvent dispatched.
		*/
		private function oPlay(e:MouseEvent):void {
			playButton.removeEventListener(MouseEvent.CLICK, oPlay);
			phase = 0;
			main.oHideSettings();
			addEventListener(Event.ENTER_FRAME, oEF, false, 0, true);
		}	
		
		/**
		* Runs every frame during animated transitions.
		* 	Phase 1 - Fading out playButton.
		* 	Phase 2 - Move title to top right and scale to 0.4. LTrigger main.oPlay.
		* 	Phase 3 - Move title back to center position, scale to 1.
		* 	Phase 4 - Fades in playButton.
		* 	Phase 5 - Add event to playButton, removes transition event.
		* 
		* @param e Event enterframe dispatched each frame.
		*/
		private function oEF(e:Event):void {
			switch(phase) {
				case 0:
					playButton.alpha += (0 - playButton.alpha) * 0.4;
					if (playButton.alpha <= 0.02) {
						phase = 1;
						playButton.visible = false;
					}
					break;
					
				case 1:
					x += (10 - x) * 0.3;
					y += (0 - y) * 0.3;
					titleTf.x += (0 - titleTf.x) * 0.3;
					titleTf.y += (0 - titleTf.y) * 0.3;
					titleTf.scaleX += (0.4 - titleTf.scaleX) * 0.3;
					titleTf.scaleY = titleTf.scaleX;
					if (titleTf.scaleX <= 0.41) {
						phase = 2;
						titleTf.x = 0;
						titleTf.y = 0;
						titleTf.scaleX = 0.4;
						titleTf.scaleY = 0.4;
						x = 10;
						y = 0;
					}
					break;	
					
				case 2:					
					removeEventListener(Event.ENTER_FRAME, oEF);
					main.oPlay(null);
					break;
					
				case 3:
					x += (stage.stageWidth/2 - x) * 0.3;
					y += (stage.stageHeight/2 - y) * 0.3;
					titleTf.x += (-183 - titleTf.x) * 0.3;
					titleTf.y += (-117 - titleTf.y) * 0.3;
					titleTf.scaleX += (1 - titleTf.scaleX) * 0.3;
					titleTf.scaleY = titleTf.scaleX;
					if (titleTf.scaleX >= 0.98) {
						phase = 4;
						titleTf.x = -183;
						titleTf.y = -117;
						titleTf.scaleX = 1;
						titleTf.scaleY = 1;
						x = stage.stageWidth/2;
						y = stage.stageHeight/2;
						playButton.visible = true;
					}
					break;	
					
				case 4:
					playButton.alpha += (1 - playButton.alpha) * 0.4;
					if (playButton.alpha >= 0.98) {
						phase = 5;
					}
					break;
					
				case 5:			
					phase = 0;
					removeEventListener(Event.ENTER_FRAME, oEF);
					playButton.addEventListener(MouseEvent.CLICK, oPlay, false, 0, true);
					break;
			}
		}
		
		/**
		* Starts animations to fade in menu.
		* 
		*/
		public function fadeIn():void {
			phase = 3;
			addEventListener(Event.ENTER_FRAME, oEF, false, 0, true);
		}
		
		/**
		* Resizes menu to center position upon initialization or stage size changing.
		*/
		public function oResize():void {
			if(phase == 0 || phase == 4){
				x = stage.stageWidth / 2;
				y = stage.stageHeight / 2;
			}else if(phase == 2){
				x = 10;
				y = 0;
			}
		}
	}	
}