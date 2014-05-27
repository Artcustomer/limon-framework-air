/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	
	/**
	 * DeviceInputsEvent
	 * 
	 * @author David Massenot
	 */
	public class DeviceInputsEvent extends Event {
		public static const DEVICE_BACK:String = 'deviceBack';
		public static const DEVICE_SEARCH:String = 'deviceSearch';
		public static const DEVICE_MENU:String = 'deviceMenu';
		public static const DEVICE_HOME:String = 'deviceHome';
		
		private var _keyboardEvent:KeyboardEvent;
		private var _keyCode:uint;
		private var _charCode:uint;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	context
		 * @param	keyboardEvent
		 * @param	keyCode
		 * @param	charCode
		 */
		public function DeviceInputsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, keyboardEvent:KeyboardEvent = null, keyCode:uint = 0, charCode:uint = 0) {
			_keyboardEvent = keyboardEvent;
			_keyCode = keyCode;
			_charCode = charCode;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone event.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new DeviceInputsEvent(type, bubbles, cancelable, _keyboardEvent, _keyCode, _charCode);
		}
		
		/**
		 * Get String value of event.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("DeviceInputsEvent", "type", "bubbles", "cancelable", "eventPhase", "keyboardEvent", "keyCode", "charCode");
		}
		
		
		/**
		 * @private
		 */
		public function get keyboardEvent():KeyboardEvent {
			return _keyboardEvent;
		}
		
		/**
		 * @private
		 */
		public function get keyCode():uint {
			return _keyCode;
		}
		
		/**
		 * @private
		 */
		public function get charCode():uint {
			return _charCode;
		}
	}
}