/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * ArrayTools : Tools for arrays.
	 * 
	 * @author David Massenot
	 */
	public class ArrayTools {
		
		
		/**
		 * Clone an Array.
		 * 
		 * @param	array
		 * @return
		 */
		public static function clone(array:Array):Array {
			if (!array) return null;
			
			var newArray:Array = new Array();
			var i:int = 0;
			var length:int = array.length;
			var line:*;
			
			for (i ; i < length ; ++i) {
				line = array[i];
				newArray.push(line);
			}
			
			return newArray;
		}
		
		/**
		 * Compare two arrays.
		 * 
		 * @param	srcArray
		 * @param	destArray
		 * @return
		 */
		public static function compare(srcArray:Array, destArray:Array):Boolean {
			var check:Boolean = true;
			
			for (var m:* in srcArray) {
				for (var n:* in destArray) {
					if (srcArray[m] == destArray[n]) {
						check = true;
						
						break;
					} else {
						check = false;
					}
				}
				
				if (!check) return false;
			}
			
			return true;
		}
		
		/**
		 * Add array data in destination array.
		 * 
		 * @param	srcArray
		 * @param	destArray
		 * @return
		 */
		public static function add(srcArray:Array, destArray:Array):Array {
			var i:int = 0;
			var length:int = srcArray.length;
			
			for (i ; i < length ; i++) {
				destArray.push(srcArray[i]);
			}
			
			return destArray;
		}
		
		/**
		 * Remove index from array.
		 * 
		 * @param	srcArray
		 * @param	index
		 */
		public static function removeAt(srcArray:Array, index:int):void {
			srcArray.splice(index, 1);
		}
	}
}