/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.system.Capabilities;
	
	
	/**
	 * StageTools : Tools for mobiles.
	 * 
	 * @author David Massenot
	 */
	public class StageTools {
		public static const SCALEFACTOR_CONFIGURATION_1:int = 1;
		public static const SCALEFACTOR_CONFIGURATION_2:int = 2;
		public static const SCALEFACTOR_CONFIGURATION_3:int = 3;
		
		
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
			var scaleFactor:Number;
			
			switch (configuration) {
				case(SCALEFACTOR_CONFIGURATION_1):
					if (minValue < 330) {
						scaleFactor = 1;
					} else if (minValue <= 480) {
						scaleFactor = 1.5;
					} else if (minValue < 1536) {
						scaleFactor = 2;
					} else {
						scaleFactor = 4;
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_2):
					if (minValue < 330) {
						scaleFactor = 1;
					} else if (minValue <= 480) {
						scaleFactor = 1.5;
					} else if (minValue < 1024) {
						scaleFactor = 2;
					} else if (minValue < 1536) {
						scaleFactor = 3;
					} else {
						scaleFactor = 4;
					}
					break;
					
				case(SCALEFACTOR_CONFIGURATION_3):
					if (minValue < 330) {
						scaleFactor = 1; //0,2
					} else if (minValue <= 480) {
						scaleFactor = 1.5; //0,3
					} else if (minValue < 1025) {
						scaleFactor = 2; //0,4
					} else if (minValue < 1537) {
						scaleFactor = 3; //0,8
					} else {
						scaleFactor = 4; //1
					}
					break;
					
				default:
					break;
			}
			
			return scaleFactor;
		}
	}
}