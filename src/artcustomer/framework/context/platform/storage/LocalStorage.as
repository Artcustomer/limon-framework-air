/*
 * Copyright (c) 2014 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context.platform.storage {
	import artcustomer.framework.base.IDestroyable;
	import artcustomer.framework.errors.IllegalError;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	
	/**
	 * LocalStorage
	 * 
	 * @author David Massenot
	 */
	public class LocalStorage implements IDestroyable {
		private static var __instance:LocalStorage;
		private static var __allowInstantiation:Boolean;
		
		private var _numItems:int;
		private var _tempBytes:ByteArray;
		private var _isSupported:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function LocalStorage() {
			if (!__allowInstantiation) {
				throw new IllegalError(IllegalError.E_SINGLETON_CLASS);
				
				return;
			}
			
			_isSupported = EncryptedLocalStore.isSupported;
			_tempBytes = new ByteArray();
			_numItems = 0;
		}
		
		
		/**
		 * Set item in local storage, update value if item exists.
		 * 
		 * @param	name
		 * @param	value
		 */
		public function set(name:String, value:Object):void {
			if (_isSupported) {
				_tempBytes.clear();
				_tempBytes.writeObject(value);
				
				if (EncryptedLocalStore.getItem(name)) {
					EncryptedLocalStore.removeItem(name);
				} else {
					++_numItems;
				}
				
				EncryptedLocalStore.setItem(name, _tempBytes);
			}
		}
		
		/**
		 * Get item from local storage.
		 * 
		 * @param	name
		 * @return
		 */
		public function get(name:String):Object {
			if (_isSupported) {
				var storedValue:ByteArray = EncryptedLocalStore.getItem(name);
				
				if (storedValue) return storedValue.readObject();
			}
			
			return null;
		}
		
		/**
		 * Test name in local storage.
		 * 
		 * @param	name
		 * @return
		 */
		public function has(name:String):Boolean {
			if (_isSupported) return EncryptedLocalStore.getItem(name) != null;
			
			return false;
		}
		
		/**
		 * Remove item from local storage.
		 * 
		 * @param	name
		 */
		public function remove(name:String):void {
			if (_isSupported) {
				EncryptedLocalStore.removeItem(name);
				
				--_numItems;
			}
		}
		
		/**
		 * Clear items in local storage.
		 */
		public function clear():void {
			if (_isSupported) {
				EncryptedLocalStore.reset();
				
				_numItems = 0;
			}
		}
		
		/**
		 * Destructor.
		 */
		public function destroy():void {
			_tempBytes.clear();
			_tempBytes = null;
			_numItems = 0;
			_isSupported = false;
			
			__instance = null;
			__allowInstantiation = false;
		}
		
		
		/**
		 * Instantiate LocalStorage.
		 */
		public static function getInstance():LocalStorage {
			if (!__instance) {
				__allowInstantiation = true;
				__instance = new LocalStorage();
				__allowInstantiation = false;
			}
			
			return __instance;
		}
		
		
		/**
		 * @private
		 */
		public function get isSupported():Boolean {
			return _isSupported;
		}
		
		/**
		 * @private
		 */
		public function get numItems():int {
			return _numItems;
		}
	}
}