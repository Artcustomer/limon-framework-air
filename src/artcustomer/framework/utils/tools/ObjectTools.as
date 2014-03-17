/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * ObjectTools : Tools for objects.
	 * 
	 * @author David Massenot
	 */
	public class ObjectTools {
		
		
		/**
		 * Parse data in Object.
		 * 
		 * @param	object
		 * @return
		 */
		public static function parse(object:Object):Array {
			if (!object) return null;
			
			var array:Array = new Array();
			var parameter:Object = null;
			var value:Object = null;
			
			for (var o:* in object) {
				parameter = o;
				value = object[o];
				
				if (value == '') {
					value = parse(value);
					
					if (value) if (value.length != 0) value = '{ ' + value + ' }';
				}
				
				array.push(String(parameter) + ' : ' + String(value));
			}
			
			if (array.length == 0) array.push('null');
			
			return array;
		}
		
		/**
		 * Describe object.
		 * 
		 * @param	object
		 * @return
		 */
		public static function describe(object:*):String {
			if (object == null) return "null";
			if (object is String) return object.toString();
			if (object is Number) return object.toString();
			if (object is Function) return "(Function)";
			if (object is Array) return "[ " + (object as Array).map(function(item:*, index:int, a:Array):String { return describe(item); } ).join(", ") + " ]";
			
			var entries:Array = [];
			var className:String = getQualifiedClassName(object);
			
			for(var key:String in object) {
				if (object[key] == object) continue;
				entries.push(key + ": " + object[key]); //describe(object[key]));
			}
			
			if (entries.length > 0) return "{" + entries.join(", ") + "}";
			
			return "(" + className + ") " + object.toString();  
		}
		
		/**
		 * Describe arguments list.
		 * 
		 * @param	args
		 * @return
		 */
		public static function describeArgs(args:Array):Array {
			return args.map(function(item:*, index:int, array:Array):* { return describe(item); } );
		}
	}
}