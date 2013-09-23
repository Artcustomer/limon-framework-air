package artcustomer.framework.events {
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	
	
	/**
	 * GestureInputsEvent
	 * 
	 * @author David Massenot
	 */
	public class GestureInputsEvent extends Event {
		public static const GESTURE_PAN:String = 'gesturePan';
		public static const GESTURE_ROTATE:String = 'gestureRotate';
		public static const GESTURE_SWIPE:String = 'gestureSwipe';
		public static const GESTURE_ZOOM:String = 'gestureZoom';
		
		private var _gestureEvent:TransformGestureEvent;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	context
		 * @param	gestureEvent
		 */
		public function GestureInputsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, gestureEvent:TransformGestureEvent = null) {
			_gestureEvent = gestureEvent;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone event.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new GestureInputsEvent(type, bubbles, cancelable, _gestureEvent);
		}
		
		/**
		 * Get String format of event.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("GestureInputsEvent", "type", "bubbles", "cancelable", "eventPhase", "gestureEvent"); 
		}
		
		
		/**
		 * @private
		 */
		public function get gestureEvent():TransformGestureEvent {
			return _gestureEvent;
		}
	}
}