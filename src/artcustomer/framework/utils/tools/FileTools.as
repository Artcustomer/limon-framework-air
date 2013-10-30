/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * FileTools : Tools for files.
	 * 
	 * @author David Massenot
	 */
	public class FileTools {
		private static const SIZE_LEVELS:Array = ['octet(s)', 'Ko', 'Mo', 'Go', 'To', 'Po', 'Eo', 'Zo', 'Yo'];
		
		
		/**
		 * Get a file extension.
		 * 
		 * @param file
		 * @return String extension
		 */
		public static function getExtension(file:String):String {
			return file.substring(file.lastIndexOf('.') + 1, file.length);
		}
		
		/**
		 * Get a file in a path
		 * 
		 * @param path
		 * @return String file
		 */
		public static function resolveFileInPath(path:String):String {
			return path.substr(path.lastIndexOf('/') + 1);
		}
		
		/**
		 * Get file name without extension
		 * 
		 * @param file
		 * @return String file
		 */
		public static function resolveFileName(file:String):String {
			return file.substr(0, file.lastIndexOf('.'));
		}
		
		/**
		 * Escape scale and rename file.
		 * 
		 * @param	file
		 * @param	scale
		 * @return
		 */
		public static function escapeScaleFromFileName(file:String, scale:Number):String {
			if (file.indexOf('{0}') != -1) file = file.split('{0}').join(scale.toString());
			
			return file;
		}
		
		/**
		 * Convert bytes to String format.
		 * 
		 * @param	bytes
		 * @return
		 */
		public static function bytesToString(bytes:Number):String {
			var index:uint = Math.floor(Math.log(bytes) / Math.log(1024));
			return (bytes / Math.pow(1024, index)).toFixed(2) + ' ' + SIZE_LEVELS[index];
		}
	}
}