package  com.superjai.connect4
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * A single Eye for the face of the game tile.
	 * @author Jeremy Weeks
	 */
	public class Eye extends MovieClip
	{
		private var homePosition:Point;
		private var limits:Point = new Point(50, 70);
		private var moveTo:Point = new Point();
		private var delay:int;
		private var lid1Rot:int;
		private var lidDis:int = 5;
		private var blinkingPhase:int = 0;
		public var ready:Boolean = true;
		public var clone:Boolean = false;
		public var speed:Number = 0.4;
		
		public function Eye():void {
			homePosition = new Point(pupil.x, pupil.y);	//Set starting position
		}		
			
		/**
		* Sets the position for the pupil to move to.
		* @param p Point value contianing the x and y cooridinates to move to.
		*/
		public function pickPosition(p:Point):void {
			if (p.y != 0) 
				limits.x = 30;
			else limits.x = 50;
			moveTo = new Point(homePosition.x+p.x * limits.x , homePosition.y+p.y * limits.y);			
			ready = false;		
		}	
		
		/**
		* Sets the emotion of the eye. Determines the position and rotation of the eyelid.
		* If eye is a clone flip the rotation.
		* @param _lidDis Distance from the pupil to the eyelid on the y axis.
		* @param _lidRot Rotation of eyelid to convey emotion.
		*/
		public function setEmotion(_lidDis:int, _lidRot:int):void {
			lidDis = _lidDis;
			lid1Rot = _lidRot;
			if (clone) lid1Rot *= -1;
		}
		
		/**
		* Initiates blinking
		* 
		*/
		public function blink():void {
			blinkingPhase = 1;
			ready = false;			
		}
		
		/**
		* Runs every frame until the pupil reaches its destination and the eyelid reaches it correct rotation.
		* If eye is a clone flip the rotation.
		* @param e Event enterframe dispatched each frame.
		*/
		public function update():void {
			if (blinkingPhase) {
				if(blinkingPhase == 1){
					lid1.y += ((pupil.y+20) - lid1.y) * 0.6;
					lid2.y += ((pupil.y-20) - lid2.y) * 0.6;
					lid2.rotation += (lid1Rot - lid2.rotation) * 0.6;
					if (Math.abs(lid2.y - (pupil.y-20)) < 2 && Math.abs(lid1.y - (pupil.y+20)) < 2) {
						blinkingPhase = 2;	
					}
				}else if(blinkingPhase == 3){
					lid1.y += ((pupil.y - lidDis) - lid1.y) * 0.6;
					lid2.y += (70 - lid2.y) * 0.8;
					if (Math.abs(lid2.y - 70) && Math.abs(lid1.y - (pupil.y - lidDis))<2) {
						blinkingPhase = 0;
						ready = true;
					}
				}else {
					blinkingPhase++;
				}
			}else{
				pupil.x  += (moveTo.x - pupil.x) * speed;	
				pupil.y  += (moveTo.y - pupil.y) * speed;	
				lid1.y += ((pupil.y - lidDis) - lid1.y) * speed;
				lid1.rotation += (lid1Rot - lid1.rotation) * speed;	
				
				if (Math.abs(pupil.x - moveTo.x) < 2 && Math.abs(pupil.y - moveTo.y ) < 2 && Math.abs(lid1Rot - lid1.rotation) < 2) {
					ready = true;	
				}
			}				
		}
		
		/**
		* Sets the pupil to follow the mouse.
		* @param _delay Number of frames to follow the mouse.
		*/
		public function followMouse(_delay:int = 0):void {
			delay = _delay;
			ready = false;
			addEventListener(Event.ENTER_FRAME, oMouseFollow, false, 0, true);	
		}	
		
		/**
		* Runs every frame while delay is above 0. Moves the pupil and eyelid so they appear to be following the mouse.
		* @param e Event enterframe dispatched each frame.
		*/
		private function oMouseFollow(e:Event):void {			
			var theX:int = mouseX - homePosition.x;
			var theY:int = (mouseY - homePosition.y);
			var angle = Math.atan2(theY,theX);
			
			var point:Point = new Point(homePosition.x + limits.x * Math.cos(angle), homePosition.y + limits.y * Math.sin(angle));;
			
			pupil.x += (point.x-pupil.x)*speed;
			pupil.y += (point.y-pupil.y)*speed;
			lid1.y += ((pupil.y - lidDis) - lid1.y)*speed;;
			
			if (delay > 0) {
				delay--;
			}else {
				ready = true;
				removeEventListener(Event.ENTER_FRAME, oMouseFollow);	
			}			
		}
	}	
}