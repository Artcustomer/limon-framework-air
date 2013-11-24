/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.xml.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * StringTools : Tools for String objects.
	 * 
	 * @author David Massenot
	 */
	public class StringTools {
		
		
		/**
		 * Format to string.
		 * 
		 * @param	object
		 * @param	className
		 * @param	...properties
		 * @return
		 */
		public static function formatToString(object:*, className:String, ...properties:*):String {
			var i:int = 0
			var s:String = '[' + className;
			var prop:String;
			
			for (i ; i < properties.length ; i++) {
				prop = properties[i];
				
				s += ' ' + prop + '=' + object[prop];
			}
			
			return s + ']';
        }
		
		/**
		 * Escape HTML chars.
		 * 
		 * @param	string
		 * @return
		 */
		public static function escapeHTML(string:String):String {
			if (!string) return '';
			
			return XML(new XMLNode(XMLNodeType.TEXT_NODE, string)).toXMLString();
		}
		
		/**
		 * Unescape HTML chars.
		 * 
		 * @param	string
		 * @return
		 */
		public static function unescapeHTML(string:String):String {
			if (!string) return '';
			
			return new XMLDocument(string).firstChild.nodeValue;
		}
		
		/**
		 * Unescape HTML entities.
		 * 
		 * @param	string
		 * @return
		 */
		public static function unescapeHTMLEntities(string:String):String {
			if (!string) return '';
			
			var tf:TextField = new TextField();
			tf.htmlText = unescape(string);
			
			return tf.text;
		}
		
		/**
		 * Replace value in String.
		 * 
		 * @param	text
		 * @param	key
		 * @param	value
		 * @return
		 */
		public static function replaceInString(text:String, key:String, value:String):String {
			return text.split(key).join(value);
		}
		
		/**
		 * Truncate text with ellipsis.
		 * 
		 * @param	chars
		 * @param	textFormat
		 * @param	maxWidth
		 * @return
		 */
		public static function truncateWithEllipsis(chars:String, textFormat:TextFormat, maxWidth:Number):String {
			var text:String = chars;
			var ellipsis:String = '...';
			var i:int;
			var textField:TextField = new TextField();
			if (textFormat) textField.defaultTextFormat = textFormat;
			textField.text = chars;
			
			if (textField.textWidth > maxWidth) {
				for (i = text.length - 1 ; i >= 0 ; --i) {
					if (text.charAt(i - 1) != ' ') {
						textField.text = text.substring(0, i - 1) + ellipsis;
					} else {
						if (textField.textWidth < maxWidth) {
							break;
						}
					}
				}
			}
			
			if (textField.text != ellipsis) return textField.text;
			
			return chars;
		}
		
		
		/**
		 * Clone Textfield.
		 * 
		 * @param	original
		 * @param	text
		 * @return
		 */
		public static function cloneTextField(original:TextField, text:String = null):TextField {
			var clone:TextField = new TextField();
			
			if (text !== null) clone.text = text;
			clone.setTextFormat(original.getTextFormat());
			clone.defaultTextFormat = original.getTextFormat();
			clone.autoSize = original.autoSize;
			clone.wordWrap = original.wordWrap;
			clone.embedFonts = original.embedFonts;
			clone.antiAliasType = original.antiAliasType;
			
			return clone;
		}
	}
}