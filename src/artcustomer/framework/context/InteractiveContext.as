/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.utils.getQualifiedClassName;
	import flash.system.Capabilities;
	
	import artcustomer.framework.context.ui.logo.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.consts.*;
	
	[Event(name = "error", type = "artcustomer.framework.events.ContextErrorEvent")]
	[Event(name = "frameworkError", type = "artcustomer.framework.events.ContextErrorEvent")]
	[Event(name = "illegalError", type = "artcustomer.framework.events.ContextErrorEvent")]
	[Event(name = "applicationFocusIn", type = "artcustomer.framework.events.ApplicationEvent")]
	[Event(name = "applicationFocusOut", type = "artcustomer.framework.events.ApplicationEvent")]
	[Event(name = "applicationExit", type = "artcustomer.framework.events.ApplicationEvent")]
	
	
	/**
	 * InteractiveContext
	 * 
	 * @author David Massenot
	 */
	public class InteractiveContext extends EventContext implements IContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::InteractiveContext';
		
		private var _contextView:DisplayObjectContainer;
		private var _contextWidth:int;
		private var _contextHeight:int;
		private var _contextMinWidth:int;
		private var _contextMinHeight:int;
		private var _fullScreenWidth:int;
		private var _fullScreenHeight:int;
		private var _stageWidth:int;
		private var _stageHeight:int;
		private var _contextPosition:String;
		private var _scaleToStage:Boolean;
		private var _screenOrientation:String;
		private var _scaleFactor:Number;
		
		private var _viewPortContainer:Sprite;
		private var _headUpContainer:Sprite;
		
		private var _logo:ContextLogo;
		
		private var _logoAlign:String;
		private var _logoVerticalMargin:int;
		private var _logoHorizontalMargin:int;
		
		private var _allowSetContextView:Boolean;
		private var _isLogoShow:Boolean;
		private var _isFocusOnStage:Boolean;
		private var _exitOnUnfocus:Boolean;
		
		protected var _isHD:Boolean;
		protected var _isDesktop:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function InteractiveContext() {
			_allowSetContextView = true;
			
			_contextView = null;
			_contextWidth = 540;
			_contextHeight = 960;
			_contextMinWidth = 540;
			_contextMinHeight = 960;
			_contextPosition = ContextPosition.TOP_LEFT;
			_scaleToStage = true;
			_screenOrientation = ScreenOrientation.PORTRAIT;
			
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_INTERACTIVECONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_isLogoShow = false;
			_isDesktop = Capabilities.playerType == 'Desktop' ? true : false;
		}
		
		//---------------------------------------------------------------------
		//  LoaderInfo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLoaderInfo():void {
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyLoaderInfo():void {
			if (_contextView.loaderInfo) _contextView.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError);
		}
		
		//---------------------------------------------------------------------
		//  NativeApplication
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupNativeApplication():void {
			NativeApplication.nativeApplication.menu = new NativeMenu();
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleNativeApplication);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleNativeApplication);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, handleNativeApplication);
		}
		
		/**
		 * @private
		 */
		private function destroyNativeApplication():void {
			NativeApplication.nativeApplication.menu = null;
			
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, handleNativeApplication);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, handleNativeApplication);
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, handleNativeApplication);
		}
		
		//---------------------------------------------------------------------
		//  StageEvents
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function listenStageEvents():void {
			_contextView.stage.addEventListener(Event.ACTIVATE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.DEACTIVATE, handleStage, false, 0, true);
			_contextView.stage.addEventListener(Event.RESIZE, handleStage, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function unlistenStageEvents():void {
			_contextView.stage.removeEventListener(Event.ACTIVATE, handleStage);
			_contextView.stage.removeEventListener(Event.DEACTIVATE, handleStage);
			_contextView.stage.removeEventListener(Event.RESIZE, handleStage);
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStage(e:Event):void {
			if (!_contextView) return;
			
			var contextWidth:int = Math.max(_contextMinWidth, _contextView.stage.fullScreenWidth);
			var contextHeight:int = Math.max(_contextMinHeight, _contextView.stage.fullScreenHeight);
			
			e.preventDefault();
			
			switch (e.type) {
				case(Event.ACTIVATE):
					if (!_isFocusOnStage) {
						_isFocusOnStage = true;
						
						this.focus();
					}
					break;
					
				case(Event.DEACTIVATE):
					if (_isFocusOnStage) {
						_isFocusOnStage = false;
						
						this.unfocus();
						
						if (_exitOnUnfocus) forceToExit();
					}
					break;
					
				case(Event.RESIZE):
					setupSize(contextWidth, contextHeight);
					refreshView();
					setLogoPosition();
					
					this.resize();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleNativeApplication(e:Event):void {
			if (!_contextView) return;
			
			var stageWidth:int = _contextView.stage.fullScreenWidth;
			var stageHeight:int = _contextView.stage.fullScreenHeight;
			var contextWidth:int = Math.max(_contextMinWidth, stageWidth);
			var contextHeight:int = Math.max(_contextMinHeight, stageHeight);
			
			e.preventDefault();
			
			switch (e.type) {
				case(Event.ACTIVATE):
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
					
					if (!_isFocusOnStage) {
						_isFocusOnStage = true;
						
						this.dispatchEvent(new ApplicationEvent(ApplicationEvent.APPLICATION_FOCUS_IN, false, false, contextWidth, contextHeight, stageWidth, stageHeight));
					}
					break;
					
				case(Event.DEACTIVATE):
					if (_isFocusOnStage) {
						_isFocusOnStage = false;
						
						this.dispatchEvent(new ApplicationEvent(ApplicationEvent.APPLICATION_FOCUS_OUT, false, false, contextWidth, contextHeight, stageWidth, stageHeight));
						
						if (_exitOnUnfocus) forceToExit();
					}
					break;
					
				case(Event.EXITING):
					prepareToExit();
					break;
					
				default:
					break;
			}
			
			e.stopPropagation();
		}
		
		/**
		 * @private
		 */
		private function handleUncaughtError(e:UncaughtErrorEvent):void {
			e.preventDefault();
			
			var error:Error = e.error as Error;
			var errorID:int = error.errorID;
			var errorName:String = ErrorName.FLASH_ERROR;
			var frameworkError:int = errorID / FrameworkError.ERROR_ID;
			var illegalError:int = errorID / IllegalError.ERROR_ID;
			var eventType:String = ContextErrorEvent.ERROR;
			
			if (frameworkError == 1) {
				eventType = ContextErrorEvent.FRAMEWORK_ERROR;
				errorName = ErrorName.FRAMEWORK_ERROR;
			}
			
			if (illegalError == 1) {
				eventType = ContextErrorEvent.ILLEGAL_ERROR;
				errorName = ErrorName.ILLEGAL_ERROR;
			}
			
			this.dispatchEvent(new ContextErrorEvent(eventType, true, false, error, errorName))
		}
		
		//---------------------------------------------------------------------
		//  ViewPortContainer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPortContainer():void {
			_viewPortContainer = new Sprite();
			
			_contextView.addChild(_viewPortContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyViewPortContainer():void {
			if (_viewPortContainer) {
				_contextView.removeChild(_viewPortContainer);
				
				_viewPortContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  HeadUpContainer
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupHeadUpContainer():void {
			_headUpContainer = new Sprite();
			
			_contextView.addChild(_headUpContainer);
		}
		
		/**
		 * @private
		 */
		private function destroyHeadUpContainer():void {
			if (_headUpContainer) {
				_contextView.removeChild(_headUpContainer);
				
				_headUpContainer = null;
			}
		}
		
		//---------------------------------------------------------------------
		//  Logo
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLogo():void {
			if (!_logo) {
				_logo = new ContextLogo();
				_logo.setup();
				
				if (_headUpContainer && _logo.bitmap) _headUpContainer.addChild(_logo.bitmap);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyLogo():void {
			if (_logo) {
				if (_headUpContainer && _logo.bitmap) _headUpContainer.removeChild(_logo.bitmap);
				
				_logo.destroy();
				_logo = null;
			}
		}
		
		/**
		 * @private
		 */
		private function setLogoPosition():void {
			if (_logo) {
				if (_logoAlign == LogoPosition.TOP_LEFT || _logoAlign == LogoPosition.LEFT || _logoAlign == LogoPosition.BOTTOM_LEFT) _logo.x = _logoHorizontalMargin;
				if (_logoAlign == LogoPosition.TOP || _logoAlign == LogoPosition.BOTTOM) _logo.x = (_contextWidth - _logo.width) >> 1;
				if (_logoAlign == LogoPosition.TOP_RIGHT || _logoAlign == LogoPosition.RIGHT || _logoAlign == LogoPosition.BOTTOM_RIGHT) _logo.x = _contextWidth - _logoHorizontalMargin - _logo.width;
				if (_logoAlign == LogoPosition.TOP_LEFT || _logoAlign == LogoPosition.TOP || _logoAlign == LogoPosition.TOP_RIGHT) _logo.y = _logoVerticalMargin;
				if (_logoAlign == LogoPosition.LEFT || _logoAlign == LogoPosition.RIGHT) _logo.y = (_contextHeight - _logo.height) >> 1;
				if (_logoAlign == LogoPosition.BOTTOM_LEFT || _logoAlign == LogoPosition.BOTTOM || _logoAlign == LogoPosition.BOTTOM_RIGHT) _logo.y = _contextHeight - _logoVerticalMargin - _logo.height;
			}
		}
		
		//---------------------------------------------------------------------
		//  Size
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupSize(width:int, height:int):void {
			var minValue:Number = Math.min(width, height);
			
			if (_scaleToStage) {
				_contextWidth = width;
				_contextHeight = height;
				
				if (minValue < 330) {
					_scaleFactor = 1;
				} else if (minValue <= 480) {
					_scaleFactor = 1.5;
				} else if (minValue < 1536) {
					_scaleFactor = 2;
				} else {
					_scaleFactor = 4;
				}
				
				/*
				if (minValue < 330) {
					return 1;
				} else if (minValue <= 480) {
					return 1.5;
				} else if (minValue < 1024) {
					return 2;
				} else if (minValue < 1536) {
					return 3;
				} else {
					return 4;
				}
				*/
			} else {
				_scaleFactor = 1;
			}
			
			_fullScreenWidth = this.stageReference.fullScreenWidth;
			_fullScreenHeight = this.stageReference.fullScreenHeight;
			_stageWidth = _fullScreenWidth / _scaleFactor;
			_stageHeight = _fullScreenHeight / _scaleFactor;
			
			if (_contextWidth >= _contextHeight) {
				_screenOrientation = ScreenOrientation.LANDSCAPE;
			} else {
				_screenOrientation = ScreenOrientation.PORTRAIT;
			}
		}
		
		
		/**
		 * When player window is resized.
		 */
		protected function resize():void {
			
		}
		
		/**
		 * When FlashPlayer receive focus. Can be overrided.
		 */
		protected function focus():void {
			
		}
		
		/**
		 * When FlashPlayer lose focus. Can be overrided.
		 */
		protected function unfocus():void {
			
		}
		
		
		/**
		 * Setup InteractiveContext.
		 */
		override public function setup():void {
			init();
			
			super.setup();
			
			setupNativeApplication();
			listenStageEvents();
			setupLoaderInfo();
			setupViewPortContainer();
			setupHeadUpContainer();
			setupSize(_contextView.stage.fullScreenWidth, _contextView.stage.fullScreenHeight);
			refreshView();
			showLogo();
		}
		
		/**
		 * Destroy InteractiveContext.
		 */
		override public function destroy():void {
			hideLogo();
			destroyViewPortContainer();
			destroyHeadUpContainer();
			destroyLoaderInfo();
			destroyNativeApplication();
			unlistenStageEvents();
			
			_contextView = null;
			_contextWidth = 0;
			_contextHeight = 0;
			_contextMinWidth = 0;
			_contextMinHeight = 0;
			_fullScreenWidth = 0;
			_fullScreenHeight = 0;
			_contextPosition = null;
			_scaleToStage = false;
			_screenOrientation = null;
			_scaleFactor = 0;
			_viewPortContainer = null;
			_allowSetContextView = false;
			_isLogoShow = false;
			_isFocusOnStage = false;
			_exitOnUnfocus = false;
			_isHD = false;
			_isDesktop = false;
			
			super.destroy();
		}
		
		/**
		 * Move the context view.
		 * 
		 * @param	x
		 * @param	y
		 */
		public function move(x:int = 0, y:int = 0):void {
			if (_contextView) {
				_contextView.x = x;
				_contextView.y = y;
			}
		}
		
		/**
		 * Refresh the context view.
		 */
		public function refreshView():void {
			var xPos:int = 0;
			var yPos:int = 0;
			
			switch (_contextPosition) {
				case(ContextPosition.CENTER):
					xPos = (_contextView.stage.stageWidth - _contextWidth) >> 1;
					yPos = (_contextView.stage.stageHeight - _contextHeight) >> 1;
					break;
					
				case(ContextPosition.TOP_LEFT):
					xPos = 0;
					yPos = 0;
					break;
					
				case(ContextPosition.TOP_RIGHT):
					xPos = _contextView.stage.stageWidth - _contextWidth;
					yPos = 0;
					break;
					
				case(ContextPosition.BOTTOM_LEFT):
					xPos = 0;
					yPos = _contextView.stage.stageHeight - _contextHeight;
					break;
					
				case(ContextPosition.BOTTOM_RIGHT):
					xPos = _contextView.stage.stageWidth - _contextWidth;
					yPos = _contextView.stage.stageHeight - _contextHeight;
					break;
					
				default:
					xPos = 0;
					yPos = 0;
					break;
			}
			
			if (!_scaleToStage) move(xPos, yPos);
		}
		
		/**
		 * Send event to prepare application exiting.
		 */
		public function prepareToExit():void {
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.APPLICATION_EXIT, false, false, contextWidth, contextHeight, _contextView.stage.stageWidth, _contextView.stage.stageHeight));
		}
		
		/**
		 * Force to terminate application.
		 * 
		 * @param	errorCode
		 */
		public function forceToExit(errorCode:int = 0):void {
			NativeApplication.nativeApplication.exit(errorCode);
		}
		
		/**
		 * Show Framework logo.
		 */
		public function showLogo():void {
			if (!_isLogoShow) {
				setupLogo();
				setLogoPosition();
				
				_isLogoShow = true;
			}
		}
		
		/**
		 * Hide Framework logo.
		 */
		public function hideLogo():void {
			if (_isLogoShow) {
				destroyLogo();
				
				_isLogoShow = false;
			}
		}
		
		/**
		 * Move Framework logo.
		 * 
		 * @param	align : Use consts of LogoPosition
		 * @param	verticalMargin
		 * @param	horizontalMargin
		 */
		public function moveLogo(align:String, verticalMargin:int = 0, horizontalMargin:int = 0):void {
			if (_isLogoShow) {
				_logoAlign = align;
				_logoVerticalMargin = verticalMargin;
				_logoHorizontalMargin = horizontalMargin;
				
				setLogoPosition();
			}
		}
		
		/**
		 * Test if context is on debug mode
		 * 
		 * @return
		 */
		public function isDebugMode():Boolean {
			return false;
		}
		
		
		/**
		 * @private
		 */
		public function set contextView(value:DisplayObjectContainer):void {
			if (_allowSetContextView) {
				_contextView = value;
				
				_allowSetContextView = false;
			}
		}
		
		/**
		 * @private
		 */
		public function get contextView():DisplayObjectContainer {
			return _contextView;
		}
		
		/**
		 * @private
		 */
		public function set contextWidth(value:int):void {
			_contextWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get contextWidth():int {
			return _contextWidth;
		}
		
		/**
		 * @private
		 */
		public function set contextHeight(value:int):void {
			_contextHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get contextHeight():int {
			return _contextHeight;
		}
		
		/**
		 * @private
		 */
		public function set contextMinWidth(value:int):void {
			_contextMinWidth = value;
		}
		
		/**
		 * @private
		 */
		public function get contextMinWidth():int {
			return _contextMinWidth;
		}
		
		/**
		 * @private
		 */
		public function set contextMinHeight(value:int):void {
			_contextMinHeight = value;
		}
		
		/**
		 * @private
		 */
		public function get contextMinHeight():int {
			return _contextMinHeight;
		}
		
		/**
		 * @private
		 */
		public function get fullScreenWidth():int {
			return _fullScreenWidth;
		}
		
		/**
		 * @private
		 */
		public function get fullScreenHeight():int {
			return _fullScreenHeight;
		}
		
		/**
		 * @private
		 */
		public function get stageWidth():int {
			return _stageWidth;
		}
		
		/**
		 * @private
		 */
		public function get stageHeight():int {
			return _stageHeight;
		}
		
		/**
		 * @private
		 */
		public function set contextPosition(value:String):void {
			_contextPosition = value;
		}
		
		/**
		 * @private
		 */
		public function get contextPosition():String {
			return _contextPosition;
		}
		
		/**
		 * @private
		 */
		public function set scaleToStage(value:Boolean):void {
			_scaleToStage = value;
		}
		
		/**
		 * @private
		 */
		public function get scaleToStage():Boolean {
			return _scaleToStage;
		}
		
		/**
		 * @private
		 */
		public function set exitOnUnfocus(value:Boolean):void {
			_exitOnUnfocus = value;
		}
		
		/**
		 * @private
		 */
		public function get exitOnUnfocus():Boolean {
			return _exitOnUnfocus;
		}
		
		/**
		 * @private
		 */
		public function get stageReference():Stage {
			return _contextView.stage;
		}
		
		/**
		 * @private
		 */
		public function get viewPortContainer():Sprite {
			return _viewPortContainer;
		}
		
		/**
		 * @private
		 */
		public function get headUpContainer():Sprite {
			return _headUpContainer;
		}
		
		/**
		 * @private
		 */
		public function get isFocusOnStage():Boolean {
			return _isFocusOnStage;
		}
		
		/**
		 * @private
		 */
		public function get screenOrientation():String {
			return _screenOrientation;
		}
		
		/**
		 * @private
		 */
		public function get scaleFactor():Number {
			return _scaleFactor;
		}
		
		/**
		 * @private
		 */
		public function get isHD():Boolean {
			return _isHD;
		}
		
		/**
		 * @private
		 */
		public function get isDesktop():Boolean {
			return _isDesktop;
		}
	}
}