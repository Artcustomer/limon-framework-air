/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.system.Security;
	import flash.desktop.NativeApplication;
	import flash.utils.getQualifiedClassName;
	import flash.filesystem.File;
	
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.consts.*;
	
	
	/**
	 * ServiceContext
	 * 
	 * @author David Massenot
	 */
	public class ServiceContext extends CrossPlatformInputsContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::ServiceContext';
		
		private var _name:String;
		private var _mode:String;
		private var _device:String;
		private var _rootFolder:String;
		private var _assetsPath:String;
		private var _storagePath:String;
		private var _fullRootPath:String;
		private var _fullAssetsPath:String;
		
		private var _runtime:String;
		private var _runtimeVersion:String;
		private var _flashVersion:String;
		private var _airVersion:String;
		private var _operatingSystem:String;
		private var _bitsProcessesSupported:String;
		private var _cpuArchitecture:String;
		private var _framerate:Number;
		private var _playerType:String;
		private var _touchscreenType:String;
		private var _defaultLanguage:String;
		private var _appLanguage:String;
		private var _manufacturer:String;
		
		private var _isPlayerPaused:Boolean;
		private var _createRootPath:Boolean;
		private var _testAssetsPath:Boolean;
		private var _isiOS:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function ServiceContext() {
			_device = DeviceTypes.CROSS_DEVICE;
			_runtime = RuntimePlatform.AIR_RUNTIME;
			_runtimeVersion = NativeApplication.nativeApplication.runtimeVersion;
			_flashVersion = Capabilities.version;
			_airVersion = NativeApplication.nativeApplication.runtimeVersion;
			_operatingSystem = Capabilities.os;
			_bitsProcessesSupported = BitProcesses.UNKNOWN_SUPPORT;
			_cpuArchitecture = Capabilities.cpuArchitecture;
			_defaultLanguage = Capabilities.language;
			_appLanguage = ApplicationLanguages.FRENCH;
			_name = ContextName.DEFAULT_NAME;
			_mode = ContextMode.RELEASE;
			_rootFolder = '';
			_assetsPath = '';
			_storagePath = StoragePath.APPLICATION_DIRECTORY;
			_playerType = Capabilities.playerType;
			_touchscreenType = Capabilities.touchscreenType;
			
			setManufacturer();
			
			if (Capabilities.supports32BitProcesses) _bitsProcessesSupported = BitProcesses.SUPPORT_32_BIT;
			if (Capabilities.supports64BitProcesses) _bitsProcessesSupported = BitProcesses.SUPPORT_64_BIT;
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_SERVICECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Manufacturer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setManufacturer():void {
			var manufacturer:String = Capabilities.manufacturer;
			
			if (manufacturer.indexOf(DevicesManufacturers.WINDOWS) != -1) {
				_manufacturer = DevicesManufacturers.WINDOWS;
			}
			
			if (manufacturer.indexOf(DevicesManufacturers.MAC) != -1) {
				_manufacturer = DevicesManufacturers.MAC;
			}
			
			if (manufacturer.indexOf(DevicesManufacturers.LINUX) != -1) {
				_manufacturer = DevicesManufacturers.LINUX;
			}
			
			if (manufacturer.indexOf(DevicesManufacturers.ANDROID) != -1) {
				_manufacturer = DevicesManufacturers.ANDROID;
			}
			
			if (manufacturer.indexOf(DevicesManufacturers.IOS) != -1) {
				_manufacturer = DevicesManufacturers.IOS;
				_isiOS = true;
			}
		}
		
		//---------------------------------------------------------------------
		//  Assets
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function testAssets():void {
			var file:File;
			var rootFile:File;
			
			switch (_storagePath) {
				case(StoragePath.APPLICATION_DIRECTORY):
				default:
					file = File.applicationDirectory.resolvePath(_rootFolder);
					break;
					
				case(StoragePath.APPLICATION_STORAGE_DIRECTORY):
					file = File.applicationStorageDirectory.resolvePath(_rootFolder);
					break;
					
				case(StoragePath.DESKTOP_DIRECTORY):
					file = File.desktopDirectory.resolvePath(_rootFolder);
					break;
					
				case(StoragePath.USER_DIRECTORY):
					file = File.userDirectory.resolvePath(_rootFolder);
					break;
					
				case(StoragePath.DOCUMENTS_DIRECTORY):
					file = File.documentsDirectory.resolvePath(_rootFolder);
					break;
			}
			
			if (_createRootPath) {
				if (!file.exists) file.createDirectory();
				_fullRootPath = file.url + '/';
				
				// Not work on DOCUMENTS_DIRECTORY on Android
				/*file = file.resolvePath(file.url + '/' + _assetsPath);
				if (!file.exists) file.createDirectory();
				_fullAssetsPath = file.url + '/';*/
			} else {
				if (_rootFolder != '') _fullRootPath = file.url + '/';
				if (_assetsPath != '') _fullAssetsPath = file.url + '/' + _assetsPath;
			}
			
			if (_testAssetsPath) if (!file.exists) throw new FrameworkError(FrameworkError.E_ASSETS_PATH_DONT_EXIST + ' "' + _rootFolder + _assetsPath + '" in ' + _storagePath.toString());
		}
		
		
		/**
		 * Setup ServiceContext.
		 */
		override public function setup():void {
			super.setup();
			
			testAssets();
		}
		
		/**
		 * Destroy ServiceContext.
		 */
		override public function destroy():void {
			_name = null;
			_mode = null;
			_device = null;
			_rootFolder = null;
			_assetsPath = null;
			_storagePath = null;
			_fullAssetsPath = null;
			_runtime = null;
			_runtimeVersion = null;
			_flashVersion = null;
			_airVersion = null;
			_operatingSystem = null;
			_cpuArchitecture = null;
			_playerType = null;
			_touchscreenType = null;
			_defaultLanguage = null
			_appLanguage = null
			_manufacturer = null
			_framerate = 0;
			_isPlayerPaused = false;
			_createRootPath = false;
			_testAssetsPath = false;
			_isiOS = false;
			
			super.destroy();
		}
		
		/**
		 * Test if context is on debug mode
		 * 
		 * @return
		 */
		override public function isDebugMode():Boolean {
			return _mode == ContextMode.RELEASE ? false : true;
		}
		
		/**
		 * Force the garbage collection process.
		 */
		public function releaseMemory():void {
			System.gc();
		}
		
		/**
		 * Exit Flash Player.
		 * 
		 * @param	code : A value to pass to the operating system.
		 */
		public function exitPlayer(code:uint = 0):void {
			System.exit(code);
		}
		
		/**
		 * Pause Flash Player
		 */
		public function pausePlayer():void {
			if (!_isPlayerPaused) {
				_isPlayerPaused = true;
				
				System.pause();
			}
		}
		
		/**
		 * Resume Flash Player
		 */
		public function resumePlayer():void {
			if (_isPlayerPaused) {
				_isPlayerPaused = false;
				
				System.resume();
			}
		}
		
		/**
		 * Send message from framework. Override it !
		 * 
		 * @param	message
		 */
		public function sendExternalMessage(message:String):void {
			
		}
		
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set mode(value:String):void {
			_mode = value;
		}
		
		/**
		 * @private
		 */
		public function get mode():String {
			return _mode;
		}
		
		/**
		 * @private
		 */
		public function set device(value:String):void {
			_device = value;
		}
		
		/**
		 * @private
		 */
		public function get device():String {
			return _device;
		}
		
		/**
		 * @private
		 */
		public function set appLanguage(value:String):void {
			_appLanguage = value;
		}
		
		/**
		 * @private
		 */
		public function get appLanguage():String {
			return _appLanguage;
		}
		
		/**
		 * @private
		 */
		public function set rootFolder(value:String):void {
			_rootFolder = value;
		}
		
		/**
		 * @private
		 */
		public function get rootFolder():String {
			return _rootFolder;
		}
		
		/**
		 * @private
		 */
		public function set assetsPath(value:String):void {
			_assetsPath = value;
		}
		
		/**
		 * @private
		 */
		public function get assetsPath():String {
			return _assetsPath;
		}
		
		/**
		 * @private
		 */
		public function set storagePath(value:String):void {
			_storagePath = value;
		}
		
		/**
		 * @private
		 */
		public function get storagePath():String {
			return _storagePath;
		}
		
		/**
		 * @private
		 */
		public function set createRootPath(value:Boolean):void {
			_createRootPath = value;
		}
		
		/**
		 * @private
		 */
		public function get createRootPath():Boolean {
			return _createRootPath;
		}
		
		/**
		 * @private
		 */
		public function set testAssetsPath(value:Boolean):void {
			_testAssetsPath = value;
		}
		
		/**
		 * @private
		 */
		public function get testAssetsPath():Boolean {
			return _testAssetsPath;
		}
		
		/**
		 * @private
		 */
		public function get fullAssetsPath():String {
			return _fullAssetsPath;
		}
		
		/**
		 * @private
		 */
		public function get fullRootPath():String {
			return _fullRootPath;
		}
		
		/**
		 * @private
		 */
		public function get applicationDomain():ApplicationDomain {
			return this.contextView.loaderInfo.applicationDomain;
		}
		
		/**
		 * @private
		 */
		public function get nativeApplication():NativeApplication {
			return NativeApplication.nativeApplication;
		}
		
		/**
		 * @private
		 */
		public function get runtime():String {
			return _runtime;
		}
		
		/**
		 * @private
		 */
		public function get runtimeVersion():String {
			return _runtimeVersion;
		}
		
		/**
		 * @private
		 */
		public function get flashVersion():String {
			return _flashVersion;
		}
		
		/**
		 * @private
		 */
		public function get airVersion():String {
			return _airVersion;
		}
		
		/**
		 * @private
		 */
		public function get operatingSystem():String {
			return _operatingSystem;
		}
		
		/**
		 * @private
		 */
		public function get bitsProcessesSupported():String {
			return _bitsProcessesSupported;
		}
		
		/**
		 * @private
		 */
		public function get cpuArchitecture():String {
			return _cpuArchitecture;
		}
		
		/**
		 * @private
		 */
		public function get playerType():String {
			return _playerType;
		}
		
		/**
		 * @private
		 */
		public function get touchscreenType():String {
			return _touchscreenType;
		}
		
		/**
		 * @private
		 */
		public function get defaultLanguage():String {
			return _defaultLanguage;
		}
		
		/**
		 * @private
		 */
		public function get manufacturer():String {
			return _manufacturer;
		}
		
		/**
		 * @private
		 */
		public function get framerate():Number {
			_framerate = this.stageReference.frameRate;
			
			return _framerate;
		}
		
		/**
		 * @private
		 */
		public function get isPlayerPaused():Boolean {
			return _isPlayerPaused;
		}
		
		/**
		 * @private
		 */
		public function get isiOS():Boolean {
			return _isiOS;
		}
	}
}
