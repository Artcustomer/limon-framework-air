/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.system.Capabilities;
	
	
	/**
	 * MobileTools : Tools for mobiles.
	 * 
	 * @author David Massenot
	 */
	public class MobileTools {
		private static const ANDROID:String = 'AND';
		private static const IOS:String = 'IOS';
		
		
		/**
		 * Test if is an Android device.
		 * 
		 * @return
		 */
		public static function isAndroid():Boolean {
			return (Capabilities.version.substr(0, 3) == ANDROID);
		}
		
		/**
		 * Test if is an Apple device.
		 * 
		 * @return
		 */
		public static function isIOS():Boolean {
			return (Capabilities.version.substr(0, 3) == IOS);
		}
		
		/**
		 * Test if is a mobile device.
		 * 
		 * @return
		 */
		public static function isMobile():Boolean {
			return (isAndroid() || isIOS());
		}
	}
}