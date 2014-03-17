/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.process.tasks.events {
	import flash.events.Event;
	
	
	/**
	 * TaskProcesorEvent
	 * 
	 * @author David Massenot
	 */
	public class TaskProcesorEvent extends Event {
		public static const ON_START_PROCESING:String = 'onStartProcesing';
		public static const ON_PROGRESS_PROCESING:String = 'onProgressProcesing';
		public static const ON_END_PROCESING:String = 'onEndProcesing';
		public static const ON_ERROR_PROCESING:String = 'onErrorProcesing';
		public static const ON_PROGRESS_TASK:String = 'onProgressTask';
		
		private var _numTasks:int;
		private var _currentTaskIndex:int;
		private var _error:String;
		private var _data:Object;
		
		
		/**
		 * Constructor
		 * 
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	numTasks
		 * @param	currentTaskIndex
		 * @param	error
		 * @param	data
		 */
		public function TaskProcesorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, numTasks:int = 0, currentTaskIndex:int = 0, error:String = null, data:Object = null) {
			_numTasks = numTasks;
			_currentTaskIndex = currentTaskIndex;
			_error = error;
			_data = data;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clone TaskProcesorEvent.
		 * 
		 * @return
		 */
		public override function clone():Event {
			return new TaskProcesorEvent(type, bubbles, cancelable, _numTasks, _currentTaskIndex, _error, _data);
		}
		
		/**
		 * Get String format of event.
		 * 
		 * @return
		 */
		public override function toString():String {
			return formatToString("TaskProcesorEvent", "type", "bubbles", "cancelable", "eventPhase", "numTasks", "currentTaskIndex", "error", "data"); 
		}
		
		
		/**
		 * @private
		 */
		public function get numTasks():int {
			return _numTasks;
		}
		
		/**
		 * @private
		 */
		public function get currentTaskIndex():int {
			return _currentTaskIndex;
		}
		
		/**
		 * @private
		 */
		public function get error():String {
			return _error;
		}
		
		/**
		 * @private
		 */
		public function get data():Object {
			return _data;
		}
	}
}