/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	
	/**
	 * MobileTools : Tools for mobiles.
	 * 
	 * @author David Massenot
	 */
	public class MobileTools {
		private static const ANDROID:String = 'AND';
		private static const IOS:String = 'IOS';
		
		public static var tabletScreenMinimumInches:Number = 5;
		public static var screenPixelWidth:Number = NaN;
		public static var screenPixelHeight:Number = NaN;
		public static var dpi:int = Capabilities.screenDPI;
		
		
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
		
		
		/**
		 * Determines if this device is probably a tablet.
		 * 
		 * @param	stage
		 * @return
		 */
		public static function isTablet(stage:Stage):Boolean {
			const screenWidth:Number = isNaN(screenPixelWidth) ? stage.fullScreenWidth : screenPixelWidth;
			const screenHeight:Number = isNaN(screenPixelHeight) ? stage.fullScreenHeight : screenPixelHeight;
			
			return (Math.max(screenWidth, screenHeight) / dpi) >= tabletScreenMinimumInches;
		}
		
		/**
		 * Determines if this device is probably a phone.
		 * 
		 * @param	stage
		 * @return
		 */
		public static function isPhone(stage:Stage):Boolean {
			return !isTablet(stage);
		}
	}
}