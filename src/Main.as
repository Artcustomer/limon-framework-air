/**
	 * Artcustomer Framework AIR
	 * 06 / 06 / 2013
	 * 
     * @langversion 3.0
     * @playerversion AIR 3.7
     * @author David Massenot (http://artcustomer.fr)
	 * @version 3.0.0.0
**/
package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	
	/**
	 * Main
	 * 
	 * @author David Massenot
	 */
	public class Main extends Sprite {
		
		
		public function Main():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
		}
		
		private function deactivate(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}
	}
}