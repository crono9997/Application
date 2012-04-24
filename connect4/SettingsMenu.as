package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Settings menu, contains gameplay settings.
	 * Columns Rows and color selection.
	 * @author Jeremy Weeks
	 */
	public class SettingsMenu extends MovieClip
	{
		private var phase:int = 0;
		private var main:Main;
		private var moveTo:int;
		private var offset:int;
		private var settings:Object;
		private var hidden:Boolean = false;
		private var alphaTo:Number = 1;
		
		public function SettingsMenu(_main:Main, _settings:Object):void {
			main = _main;		
			settings = _settings;
			setVariables();
			rowUpButton.addEventListener(MouseEvent.CLICK, oRowUp, false, 0, true);
			rowDownButton.addEventListener(MouseEvent.CLICK, oRowDown, false, 0, true);
			colUpButton.addEventListener(MouseEvent.CLICK, oColUp, false, 0, true);
			colDownButton.addEventListener(MouseEvent.CLICK, oColDown, false, 0, true);
			playerCp.addEventListener(Event.CHANGE, oPlayerColorChange, false, 0, true);
			cpuCp.addEventListener(Event.CHANGE, oCpuColorChange, false, 0, true);
			settingsButton.addEventListener(MouseEvent.CLICK, oToggleLocation, false, 0, true);			
		}
		
		/**
		* Update colors based on color selection.
		* @param e Event Change event dispatched.
		*/
		private function oPlayerColorChange(e:Event):void { settings.playerColor = playerCp.selectedColor; setVariables(); }
		private function oCpuColorChange(e:Event):void { settings.cpuColor = cpuCp.selectedColor; setVariables(); }
		
		/**
		* Update rows/cols when arrows clicked.
		* @param e MouseEvent Click event dispatched.
		*/
		private function oRowUp(e:MouseEvent):void { settings.rows++; setVariables(); }
		private function oRowDown(e:MouseEvent):void { settings.rows--; setVariables(); }
		private function oColUp(e:MouseEvent):void { settings.cols++; setVariables(); }
		private function oColDown(e:MouseEvent):void { settings.cols--; setVariables(); }
		
		/**
		* Sets the ui to match the properties of the settings object.
		* 
		*/
		private function setVariables():void {
			if (settings.rows > 10) settings.rows = 10;
			else if (settings.rows < 2) settings.rows = 2;
			if (settings.cols > 10) settings.cols = 10;
			else if (settings.cols < 2) settings.cols = 2;
			colsTf.text = settings.cols.toString();
			rowsTf.text = settings.rows.toString();
			playerCp.selectedColor = settings.playerColor;
			cpuCp.selectedColor = settings.cpuColor;
		}
		
		/**
		* Hide menu. Return to original position and fade out.
		* 
		*/
		public function hide():void {
			alphaTo = 0;
			addEventListener(Event.ENTER_FRAME, oEF, false, 0, true);
		}	
		
		/**
		* Shows menu. Fade in.
		* 
		*/
		public function show():void {
			visible = true;
			alphaTo = 1;
			addEventListener(Event.ENTER_FRAME, oEF, false, 0, true);
		}	
		
		/**
		* Settings button clicked. Toggle position between 0 and 100.
		* @param e MouseEvent dispatched.
		*/
		private function oToggleLocation(e:MouseEvent):void {
			if (moveTo != 0) moveTo = 0;
			else moveTo = 100;
			addEventListener(Event.ENTER_FRAME, oEF, false, 0, true);
		}	
		
		/**
		* Runs every frame during animated transitions. Moves setting in/out of view, alters alpha.		* 
		* @param e Event enterframe dispatched each frame.
		*/
		private function oEF(e:Event):void {		
			offset += (moveTo - offset) * 0.4;
			alpha += (alphaTo - alpha) * 0.4;
			if (Math.abs(offset-moveTo) <= 2 && Math.abs(alpha-alphaTo)<0.1) {
				offset = moveTo;
				alpha = alphaTo;
				if (alpha == 0) {
					visible = false;
					moveTo = 0;
					offset = 0;
				}
				removeEventListener(Event.ENTER_FRAME, oEF);
			}
			oResize()
		}
		
		/**
		* Resizes menu to center position upon initialization or stage size changing.
		*/
		public function oResize():void {			
			x = stage.stageWidth;
			y = stage.stageHeight-offset;
		}
	}	
}