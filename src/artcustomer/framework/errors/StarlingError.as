/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.errors {
	
	
	/**
	 * StarlingError
	 * 
	 * @author David Massenot
	 */
	public class StarlingError extends Error {
		public static const ERROR_ID:int = 50000;
		
		
		/**
		 * Throw a StarlingError.
		 * 
		 * @param	message
		 * @param	id
		 */
		public function StarlingError(message:String = "", id:int = 0) {
			super(message, ERROR_ID + id);
		}
	}
}