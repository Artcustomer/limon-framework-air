/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.system.Capabilities;
	
	
	/**
	 * StageTools : Tools for Stage on mobiles.
	 * 
	 * @author David Massenot
	 */
	public class StageTools {
		public static const DENSITY_DEFAULT_SCALE:Number = 0.00625;
		public static const INCH:Number = 25.4;
		public static const BASE_WIDTH:int = 384;
		public static const BASE_HEIGHT:int = 512;
		
		public static const SCALEFACTOR_CONFIGURATION_1:int = 1;
		public static const SCALEFACTOR_CONFIGURATION_2:int = 2;
		public static const SCALEFACTOR_CONFIGURATION_3:int = 3;
		public static const SCALEFACTOR_CONFIGURATION_4:int = 4;
		public static const SCALEFACTOR_CONFIGURATION_5:int = 5;
		public static const SCALEFACTOR_CONFIGURATION_6:int = 6;
		public static const SCALEFACTOR_CONFIGURATION_7:int = 7;
		public static const SCALEFACTOR_CONFIGURATION_8:int = 8;
		
		
		/**
		 * Convert mm size in pixels.
		 * 
		 * @param	value
		 * @return
		 */
		public static function mmToPixels(value:Number):Number {
			return (Capabilities.screenDPI * value) / INCH;
		}
		
		/**
		 * Define scalefactor by configuration.
		 * 
		 * @param	width
		 * @param	height
		 * @param	configuration
		 * @return
		 */
		public static function getScaleFactor(width:int, height:int, configuration:int = 1):Number {
			var minValue:Number = Math.min(width, height);
			var dpi:Number = Capabilities.screenDPI;
			var scaleFactor:Number;
			
			switch (configuration) {
				case(SCALEFACTOR_CONFIGURATION_1):
					if (minValue < 480) {
						scaleFactor = 1;
					} else if (minValue < 720) {
						scaleFactor = 2;
					} else if (minValue < 1024) {
						scaleFactor = 3;
					} else {
						scaleFactor = 4;
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_2):
					minValue = Math.max(width, height);
					
					if (minValue < 640) {
						scaleFactor = 1;
					} else if (minValue < 1280) {
						scaleFactor = 2;
					} else if (minValue < 2048) {
						scaleFactor = 3;
					} else {
						scaleFactor = 4;
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_3):
					if (minValue < 330) {
						scaleFactor = 1;	// 0,2
					} else if (minValue <= 480) {
						scaleFactor = 1.5;	// 0,3
					} else if (minValue < 1025) {
						scaleFactor = 2;	// 0,4
					} else if (minValue < 1537) {
						scaleFactor = 3;	// 0,8
					} else {
						scaleFactor = 4;	// 1
					}
					break; 
					
				case(SCALEFACTOR_CONFIGURATION_4):
					if (dpi < 160) {
						scaleFactor = 2;
					} else if (dpi <= 240) {
						scaleFactor = 3;
					} else {
						scaleFactor = 4;
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_5):
					if (dpi <= 240) {
						scaleFactor = 2;
					} else {
						if (minValue <= 1536) {
							scaleFactor = 3;
						} else {
							scaleFactor = 4;
						}
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_6):
					if (dpi < 160) {
						scaleFactor = 1;	// mdpi
					} else if (dpi <= 240) {
						scaleFactor = 1.5;	// hdpi
					} else if (dpi <= 320) {
						scaleFactor = 2;	// xhdpi
					} else if (dpi <= 480) {
						scaleFactor = 3;	// xxhdpi
					} else {
						scaleFactor = 4;	// xxhdpi
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_7):
					scaleFactor = dpi * DENSITY_DEFAULT_SCALE;
					break;
					
				case(SCALEFACTOR_CONFIGURATION_8):
					scaleFactor = Math.max((width / BASE_WIDTH), (height / BASE_HEIGHT))
					break;
					
				default:
					break;
			}
			
			return scaleFactor;
		}
	}
}