/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.net {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	/**
	 * NetworkCommunication
	 * 
	 * @author David Massenot
	 */
	public class NetworkCommunication {
		private static var __instance:NetworkCommunication;
		private static var __allowInstantiation:Boolean;
		
		private var _mailRegexp:RegExp = /^[\w\-.-._]+@[\w\.-]+\.[a-z]{2,3}$/i;
		private var _telRegexp:RegExp = /^0+[0-9]{9}$/i;
		private var _safeTelRegexp:RegExp = /^[0-9]{9}$/i;
		
		/**
		 * Constructor
		 */
		public function NetworkCommunication() {
			if (!__allowInstantiation) {
				throw new Error("Singleton ! Use static method to instantiate NetworkCommunication");
				
				return;
			}
		}
		
		//---------------------------------------------------------------------
		//  Navigation
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function navigate(url:String, window:String = null):void {
			navigateToURL(new URLRequest(url), window);
		}
		
		
		/**
		 * Send mail.
		 * 
		 * @param	mail
		 */
		public function mailTo(mail:String):void {
			if (!_mailRegexp.test(mail)) return;
			
			navigate('mailto:' + mail);
		}
		
		/**
		 * Send SMS.
		 * 
		 * @param	number
		 */
		public function sendSMS(number:Number):void {
			var tempNumber:String = number.toString();
			
			if (!_mailRegexp.test(tempNumber)) {
				if (!_safeTelRegexp.test(tempNumber)) {
					return;
				} else {
					tempNumber = '0' + tempNumber;
				}
			}
			
			navigate('sms:' + number.toString());
		}
		
		/**
		 * Call number.
		 * 
		 * @param	number
		 */
		public function call(number:Number):void {
			var tempNumber:String = number.toString();
			
			if (!_mailRegexp.test(tempNumber)) {
				if (!_safeTelRegexp.test(tempNumber)) {
					return;
				} else {
					tempNumber = '0' + tempNumber;
				}
			}
			
			navigate('tel:' + number.toString());
		}
		
		/**
		 * Navigate to URL.
		 * 
		 * @param	url
		 * @param	window
		 */
		public function navigateTo(url:String, window:String = '_self'):void {
			if (url.indexOf('https://') == -1 && url.indexOf('http://') == -1) url = 'http://' + url;
			
			navigate(url, window);
		}
		
		
		/**
		 * Instantiate NetworkCommunication.
		 */
		public static function getInstance():NetworkCommunication {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new NetworkCommunication();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
	}
}