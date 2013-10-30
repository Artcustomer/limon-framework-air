/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context.root {
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * StarlingRootClass
	 * 
	 * @author David Massenot
	 */
	public class StarlingRootClass extends Sprite {
		private var _starling:Starling;
		
		
		/**
		 * Constructor
		 */
		public function StarlingRootClass() {
			this.addEventListener(Event.ADDED_TO_STAGE, added);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		/**
		 * @private
		 */
		private function added(e:Event):void {
			_starling = Starling.current;
		}
		
		/**
		 * @private
		 */
		private function removed(e:Event):void {
			_starling = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, added);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
	}
}