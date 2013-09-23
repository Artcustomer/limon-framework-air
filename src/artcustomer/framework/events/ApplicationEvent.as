/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.events {
	import flash.events.Event;
	
	import artcustomer.framework.context.IContext;
	
	
	/**
	 * ApplicationEvent
	 * 
	 * @author David Massenot
	 */
	public class ApplicationEvent extends Event {
		public static const APPLICATION_FOCUS_IN:String = 'applicationFocusIn';
		public static const APPLICATION_FOCUS_OUT:String = 'applicationFocusOut';
		public static const APPLICATION_EXIT:String = 'applicationExit';
		
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _error:String;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	contextWidth
		 * @param	contextHeight
		 * @param	stageWidth
		 * @param	stageHeight
		 * @param	error
		 */
		public function ApplicationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, contextWidth:int = 0, contextHeight:int = 0, stageWidth:int = 0, stageHeight:int = 0, error:String = null) {
			_contextWidth = contextWidth;
			_contextHeight = contextHeight;
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			_error = error;
			
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * Clone ApplicationEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new ApplicationEvent(type, bubbles, cancelable, _contextWidth, _contextHeight, _stageWidth, _stageHeight, _error);
		}
		
		/**
		 * Get String value of ApplicationEvent.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("ApplicationEvent", "type", "bubbles", "cancelable", "eventPhase", "contextWidth", "contextHeight", "stageWidth", "stageHeight", "name"); 
		}
		
		
		/**
		 * @private
		 */
		public function get contextWidth():int {
			return _contextWidth;
		}
		
		/**
		 * @private
		 */
		public function get contextHeight():int {
			return _contextHeight;
		}
		
		/**
		 * @private
		 */
		public function get stageWidth():int {
			return _stageWidth;
		}
		
		/**
		 * @private
		 */
		public function get stageHeight():int {
			return _stageHeight;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
	}
}