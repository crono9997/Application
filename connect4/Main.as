package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	
	/**
	 * Document class. Starting position.
	 * Created for IGN Code-Foo 2012.
	 * @author Jeremy Weeks
	 */
	public class Main extends MovieClip
	{
		private var mainMenu:MainMenu;
		private var settingsMenu:SettingsMenu;
		private var gameLogic:GameLogic;
		public var scoreBoard:ScoreBoard = new ScoreBoard();
		private var settings:Object = {
			cols: 7,
			rows: 6,
			playerColor: 0x900000,
			cpuColor: 0x222222
		}
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		/**
		* Adds events and loads Main Menu. Will not run until stage property is not null.
		* @param e Event ADDED_TO_STAGE dispatched once stage is not null.
		*/
		public function init(event:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(scoreBoard);
			
			settingsMenu = new SettingsMenu(this, settings);
			addChild(settingsMenu);
			
			loadMainMenu();
			
			stage.addEventListener(Event.RESIZE, oResize, false, 0, true);		
			oResize(null);
		}
		
		/**
		* Loads Main Menu, and sets gameLogic to null
		*/
		private function loadMainMenu():void {			
			if (gameLogic) {
				gameLogic = null;
			}
			mainMenu = new MainMenu(this);
			addChild(mainMenu);
			oResize(null);
		}
		
		/**
		* Loads GameLogic.
		* @param e MouseEvent dispatched.
		*/
		public function oPlay(e:MouseEvent):void {
			gameLogic = new GameLogic(this, settings);
			addChild(gameLogic);
			oResize(null);
		}	
		
		/**
		* Hide SettingsMenu.
		* 
		*/
		public function oHideSettings():void {
			settingsMenu.hide();
		}	
		
		/**
		* Loads the main menu from gameLogic class, or if retry is true restarts gamelogic.
		* @param retry Boolean decides if to restart gameLogic or load main menu.
		*/
		public function reloadMainMenu(retry:Boolean):void {
			gameLogic = null;
			if (retry) oPlay(null);
			else{
				mainMenu.fadeIn();
				settingsMenu.show();				
			}
		}
		
		/**
		* Triggered upon stage resizing. Updates positioning for all menus and gameLogic.
		* @param e Event Event.RESIZE dispatched when stage is resized.
		*/
		private function oResize(e:Event):void {
			if(gameLogic){
				gameLogic.oResize();
				graphics.clear();
				graphics.lineStyle(1, 0x4E443C, 0.7);
				graphics.drawRect(2, 2, stage.stageWidth - 4, gameLogic.quitButton.y +30);
				sig.y = gameLogic.quitButton.y +28
			}else {
				graphics.clear();
				graphics.lineStyle(1, 0x4E443C, 0.7);
				graphics.drawRect(2, 2, stage.stageWidth - 4, stage.stageHeight - 4);
				sig.y = stage.stageHeight - 2;
			}
			if (mainMenu) {
				mainMenu.oResize();
			}
			scoreBoard.x = stage.stageWidth;
			settingsMenu.oResize();
		}
	}	
}