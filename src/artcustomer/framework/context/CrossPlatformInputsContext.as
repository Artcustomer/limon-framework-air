/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.system.Capabilities;
	import flash.desktop.NativeApplication;
	import flash.utils.getQualifiedClassName;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.*;
	
	[Event(name = "inputKeyRelease", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputKeyRepeat", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputKeyFastRepeat", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseRollOver", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseRollOut", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseOver", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseOut", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseMove", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseDown", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseUp", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseClick", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseDoubleClick", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseWheelUp", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseWheelDown", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "inputMouseLeave", type = "artcustomer.framework.events.InputsEvent")]
	[Event(name = "gesturePan", type = "artcustomer.framework.events.GestureInputsEvent")]
	[Event(name = "gestureRotate", type = "artcustomer.framework.events.GestureInputsEvent")]
	[Event(name = "gestureSwipe", type = "artcustomer.framework.events.GestureInputsEvent")]
	[Event(name = "gestureZoom", type = "artcustomer.framework.events.GestureInputsEvent")]
	[Event(name = "deviceBack", type = "artcustomer.framework.events.DeviceInputsEvent")]
	[Event(name = "deviceSearch", type = "artcustomer.framework.events.DeviceInputsEvent")]
	[Event(name = "deviceMenu", type = "artcustomer.framework.events.DeviceInputsEvent")]
	[Event(name = "deviceHome", type = "artcustomer.framework.events.DeviceInputsEvent")]
	
	
	/**
	 * CrossPlatformInputsContext
	 * 
	 * @author David Massenot
	 */
	public class CrossPlatformInputsContext extends InteractiveContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::CrossPlatformInputsContext';
		
		private var _keyInputCounter:int;
		private var _keyInputRepeatDelay:int;
		private var _keyInputFastRepeatDelay:int;
		
		private var _isKeyReleased:Boolean;
		private var _isSupportsGestures:Boolean;
		
		private var _isMouseEnable:Boolean;
		private var _isKeyboardEnable:Boolean;
		private var _isTouchEnable:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function CrossPlatformInputsContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_CROSSPLATFORMINPUTSCONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 10;
			_keyInputFastRepeatDelay = 2;
			_isKeyReleased = false;
			_isMouseEnable = false;
			_isKeyboardEnable = false;
			_isTouchEnable = false;
		}
		
		//---------------------------------------------------------------------
		//  Multitouch
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupTouch():void {
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			if (Multitouch.supportedGestures == null || Multitouch.supportedGestures.length == 0 || Multitouch.supportedGestures.indexOf(TransformGestureEvent.GESTURE_SWIPE) == -1) _isSupportsGestures = false;
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleStage(e:Event):void {
			switch (e.type) {
				case(Event.MOUSE_LEAVE):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_LEAVE, false, false));
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageMouse(e:MouseEvent):void {
			switch (e.type) {
				case(MouseEvent.ROLL_OVER):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_ROLL_OVER, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.ROLL_OUT):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_ROLL_OUT, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
				
				case(MouseEvent.MOUSE_OVER):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_OVER, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_OUT):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_OUT, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_MOVE):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_MOVE, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_DOWN):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_DOWN, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_UP):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_UP, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.CLICK):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_CLICK, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.DOUBLE_CLICK):
					this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_DOUBLECLICK, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					break;
					
				case(MouseEvent.MOUSE_WHEEL):
					if (e.delta > 0) {
						this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_WHEEL_UP, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					} else {
						this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_MOUSE_WHEEL_DOWN, false, false, e, null, 0, 0, null, e.stageX, e.stageY, e.delta));
					}
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStageKeys(e:KeyboardEvent):void {
			var callPreventDefault:Boolean = false;
			
			switch (e.type) {
				case(KeyboardEvent.KEY_DOWN):
					if (!_isKeyReleased) {
						if (e.keyCode == Keyboard.MENU) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_MENU, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						if (e.keyCode == Keyboard.BACK) {
							this.dispatchEvent(new DeviceInputsEvent(Device BY.InputsEvent.DEVICE_BACK, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						if (e.keyCode == Keyboard.SEARCH) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_SEARCH, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						if (e.keyCode == Keyboard.HOME) {
							this.dispatchEvent(new DeviceInputsEvent(DeviceInputsEvent.DEVICE_HOME, false, false, e, e.keyCode, e.charCode));
							callPreventDefault = true;
						}
						
						this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_RELEASE, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
						
						if (callPreventDefault) e.preventDefault();
						
						_isKeyReleased = true;
					}
					
					++_keyInputCounter;
					
					if (_keyInputCounter % _keyInputRepeatDelay == 0) this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_REPEAT, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
					if (_keyInputCounter % _keyInputFastRepeatDelay == 0) this.dispatchEvent(new InputsEvent(InputsEvent.INPUT_KEY_FAST_REPEAT, false, false, null, e, e.keyCode, e.charCode, InputUtils.getNameByKeycode(e.keyCode)));
					break;
					
				case(KeyboardEvent.KEY_UP):
					_keyInputCounter = 0;
					_isKeyReleased = false;
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleGestures(e:TransformGestureEvent):void {
			switch (e.type) {
				case(TransformGestureEvent.GESTURE_PAN):
					this.dispatchEvent(new GestureInputsEvent(GestureInputsEvent.GESTURE_PAN, false, false, e));
					break;
					
				case(TransformGestureEvent.GESTURE_ROTATE):
					this.dispatchEvent(new GestureInputsEvent(GestureInputsEvent.GESTURE_ROTATE, false, false, e));
					break;
					
				case(TransformGestureEvent.GESTURE_SWIPE):
					this.dispatchEvent(new GestureInputsEvent(GestureInputsEvent.GESTURE_SWIPE, false, false, e));
					break;
					
				case(TransformGestureEvent.GESTURE_ZOOM):
					this.dispatchEvent(new GestureInputsEvent(GestureInputsEvent.GESTURE_ZOOM, false, false, e));
					break;
					
				default:
					break;
			}
			
			e.stopPropagation();
			e.preventDefault();
		}
		
		
		/**
		 * Called when key is released.
		 * 
		 * @param	keyCode
		 */
		protected function onReleaseKeyInput(keyCode:uint):void {
			
		}
		
		
		/**
		 * Setup CrossPlatformInputsContext.
		 */
		override public function setup():void {
			init();
			setupTouch();
			
			super.setup();
		}
		
		/**
		 * Destroy CrossPlatformInputsContext.
		 */
		override public function destroy():void {
			disableMouseInputs();
			disableKeyboardInputs();
			disableTouchInputs();
			
			_keyInputCounter = 0;
			_keyInputRepeatDelay = 0;
			_keyInputFastRepeatDelay = 0;
			_isKeyReleased = false;
			_isSupportsGestures = false;
			_isMouseEnable = false;
			_isKeyboardEnable = false;
			_isTouchEnable = false;
			
			super.destroy();
		}
		
		/**
		 * Start listening native mouse inputs
		 */
		public function enableMouseInputs():void {
			if (!_isMouseEnable) {
				_isMouseEnable = true;
				
				this.contextView.stage.addEventListener(Event.MOUSE_LEAVE, handleStage, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.ROLL_OUT, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.ROLL_OVER, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.MOUSE_OVER, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.MOUSE_OUT, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.CLICK, handleStageMouse, false, 0, true);
				this.contextView.stage.addEventListener(MouseEvent.DOUBLE_CLICK, handleStageMouse, false, 0, true);
			}
		}
		
		/**
		 * Stop listening native mouse inputs
		 */
		public function disableMouseInputs():void {
			if (_isMouseEnable) {
				_isMouseEnable = false;
				
				this.contextView.stage.removeEventListener(Event.MOUSE_LEAVE, handleStage);
				this.contextView.stage.removeEventListener(MouseEvent.ROLL_OUT, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.ROLL_OVER, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.MOUSE_OVER, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.MOUSE_OUT, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.CLICK, handleStageMouse);
				this.contextView.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, handleStageMouse);
			}
		}
		
		/**
		 * Start listening native keyboard inputs
		 */
		public function enableKeyboardInputs():void {
			if (!_isKeyboardEnable) {
				_isKeyboardEnable = true;
				
				if (Capabilities.cpuArchitecture == 'ARM') {
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys, false, 0, true);
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_UP, handleStageKeys, false, 0, true);
				} else {
					this.contextView.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys, false, 0, true);
					this.contextView.stage.addEventListener(KeyboardEvent.KEY_UP, handleStageKeys, false, 0, true);
				}
			}
		}
		
		/**
		 * Stop listening native keyboard inputs
		 */
		public function disableKeyboardInputs():void {
			if (_isKeyboardEnable) {
				_isKeyboardEnable = false;
				
				if (Capabilities.cpuArchitecture == 'ARM') {
					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys);
					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_UP, handleStageKeys);
				} else {
					this.contextView.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleStageKeys);
					this.contextView.stage.removeEventListener(KeyboardEvent.KEY_UP, handleStageKeys);
				}
			}
		}
		
		/**
		 * Start listening native touch inputs
		 */
		public function enableTouchInputs():void {
			if (!_isTouchEnable) {
				_isTouchEnable = true;
				
				if (_isSupportsGestures) {
					this.contextView.stage.addEventListener(TransformGestureEvent.GESTURE_PAN, handleGestures, false, 0, true);
					this.contextView.stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, handleGestures, false, 0, true);
					this.contextView.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, handleGestures, false, 0, true);
					this.contextView.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, handleGestures, false, 0, true);
				}
			}
		}
		
		/**
		 * Stop listening native touch inputs
		 */
		public function disableTouchInputs():void {
			if (_isTouchEnable) {
				_isTouchEnable = false;
				
				if (_isSupportsGestures) {
					this.contextView.stage.removeEventListener(TransformGestureEvent.GESTURE_PAN, handleGestures);
					this.contextView.stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, handleGestures);
					this.contextView.stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, handleGestures);
					this.contextView.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, handleGestures);
				}
			}
		}
		
		
		/**
		 * @private
		 */
		public function set keyInputRepeatDelay(value:int):void {
			_keyInputRepeatDelay = value;
		}
		
		/**
		 * @private
		 */
		public function get keyInputRepeatDelay():int {
			return _keyInputRepeatDelay;
		}
		
		/**
		 * @private
		 */
		public function set keyInputFastRepeatDelay(value:int):void {
			_keyInputFastRepeatDelay = value;
		}
		
		/**
		 * @private
		 */
		public function get keyInputFastRepeatDelay():int {
			return _keyInputFastRepeatDelay;
		}
		
		/**
		 * @private
		 */
		public function get isSupportsGestures():Boolean {
			return _isSupportsGestures;
		}
	}
}