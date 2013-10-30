/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.display.DisplayObjectContainer;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import artcustomer.framework.context.*;
	import artcustomer.framework.core.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.engines.layers.*;
	import artcustomer.framework.engines.manager.*;
	import artcustomer.framework.utils.consts.*;
	import artcustomer.framework.engines.component.StarlingComponent;
	import artcustomer.framework.context.root.StarlingRootClass;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	
	/**
	 * StarlingContext : Context of the Starling application.
	 * 
	 * @author David Massenot
	 */
	public class StarlingContext extends BaseContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::StarlingContext';
		
		private var _starling:Starling;
		private var _starlingStage:Stage;
		private var _starlingRoot:StarlingRootClass;
		
		private var _starlingSomponents:Dictionary;
		private var _managers:Dictionary;
		
		private var _numStarlingComponents:int;
		private var _numManagers:int;
		
		private var _handleLostContext:Boolean;
		
		
		/**
		 * Constructor
		 */
		public function StarlingContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_CONTEXT_CONSTRUCTOR);
			if (contextView) this.contextView = contextView;
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStage():void {
			this.stageReference.scaleMode = StageScaleMode.NO_SCALE;
			this.stageReference.quality = StageQuality.HIGH;
			this.stageReference.align = StageAlign.TOP_LEFT;
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_numStarlingComponents = 0;
			_numManagers = 0;
		}
		
		//---------------------------------------------------------------------
		//  StarlingComponents Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStarlingComponentStack():void {
			if (!_starlingSomponents) _starlingSomponents = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyStarlingComponentStack():void {
			if (_starlingSomponents) _starlingSomponents = null;
		}
		
		/**
		 * @private
		 */
		private function disposeStarlingComponentStack():void {
			if (!_starlingSomponents) return;
			
			var id:String;
			
			for (id in _starlingSomponents) {
				this.removeStarlingComponent(id);
			}
		}
		
		/**
		 * @private
		 */
		private function resizeAllStarlingComponents():void {
			var id:String;
			var component:StarlingComponent;
			
			for (id in _starlingSomponents) {
				component = _starlingSomponents[id] as StarlingComponent;
				if (component) component.contextResize();
			}
		}
		
		/**
		 * @private
		 */
		private function reorderStarlingComponentStack():void {
			var i:int;
			var id:String;
			var component:StarlingComponent;
			
			for (id in _starlingSomponents) {
				component = _starlingSomponents[id] as StarlingComponent;
				
				if (component) {
					component.index = i;
					
					i++;
				}
			}
		}
		
		//---------------------------------------------------------------------
		//  Managers Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupManagerStack():void {
			if (!_managers) _managers = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyManagerStack():void {
			if (_managers) _managers = null;
		}
		
		/**
		 * @private
		 */
		private function disposeManagerStack():void {
			if (!_managers) return;
			
			var id:String;
			
			for (id in _managers) {
				this.removeManager(id);
			}
		}
		
		//---------------------------------------------------------------------
		//  Mapping
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function mapModelData(model:IModel):void {
			if (!model.context) (model as AbstractModel).context = this;
		}
		
		//---------------------------------------------------------------------
		//  Parsing
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function parseDictionary(dictionary:Dictionary):Array {
			if (!dictionary) return null;
			
			var key:String;
			var array:Array = new Array();
			
			for (key in dictionary) {
				array.push(key);
			}
			
			return array;
		}
		
		//---------------------------------------------------------------------
		//  Starling
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupStarling():void {
			var viewPort:Rectangle;
			var starlingStageWidth:Number;
			var starlingStageHeight:Number;
			
			if (this.scaleToStage) {
				//viewPort = _isDesktop == true ? new Rectangle(0, 0, this.stageReference.fullScreenWidth, this.stageReference.fullScreenHeight) : new Rectangle(0, 0, this.stageReference.stageWidth, this.stageReference.stageHeight);
				viewPort = new Rectangle(0, 0, this.stageReference.fullScreenWidth, this.stageReference.fullScreenHeight);
				starlingStageWidth = this.stageReference.fullScreenWidth / this.scaleFactor;
				starlingStageHeight = this.stageReference.fullScreenHeight / this.scaleFactor;
			} else {
				viewPort = new Rectangle(0, 0, this.contextWidth, this.contextHeight);
				starlingStageWidth = this.contextWidth;
				starlingStageHeight = this.contextHeight;
			}
			
			try {
				Starling.multitouchEnabled = true;
				
				//this.handleLostContext = !this.isiOS;
				this.handleLostContext = true;
				
				_starling = new Starling(StarlingRootClass, this.stageReference, viewPort);
				_starling.addEventListener(Event.ROOT_CREATED, handleStarling);
				_starling.addEventListener(Event.CONTEXT3D_CREATE, handleStarling);
				_starling.stage.addEventListener(ResizeEvent.RESIZE, handleStarlingResize);
				_starling.enableErrorChecking = false;
				_starling.antiAliasing = 1;
				
				_starling.stage.stageWidth = starlingStageWidth;
				_starling.stage.stageHeight = starlingStageHeight;
				
				_starlingStage = _starling.stage;
				
				this._isHD = _starling.viewPort.width > 480;
			} catch (er:Error) {
				throw new StarlingError(er.message);
			}
		}
		
		/**
		 * @private
		 */
		private function destroyStarling():void {
			if (_starling) {
				_starling.removeEventListener(Event.ROOT_CREATED, handleStarling);
				_starling.removeEventListener(Event.CONTEXT3D_CREATE, handleStarling);
				_starling.stage.removeEventListener(ResizeEvent.RESIZE, handleStarlingResize);
				_starling.dispose();
				_starling = null;
			}
		}
		
		/**
		 * @private
		 */
		private function resizeStarling():void {
			var width:int = this.contextWidth;
			var height:int = this.contextHeight;
			var viewport:Rectangle = new Rectangle(0, 0, width, height);
			
			if (_starling) {
				_starling.viewPort = viewport;
				_starling.stage.stageWidth = width;
				_starling.stage.stageHeight= height;
			}
		}
		
		/**
		 * @private
		 */
		private function renderStarling():void {
			if (_starling) _starling.nextFrame();
		}
		
		/**
		 * @private
		 */
		private function handleStarling(e:Event):void {
			switch (e.type) {
				case(Event.ROOT_CREATED):
					if (_starling) _starlingRoot = _starling.root as StarlingRootClass;
					
					start();
					break;
					
				case(Event.CONTEXT3D_CREATE):
					if (!_starling.isStarted) _starling.start();
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function handleStarlingResize(e:ResizeEvent):void {
			switch (e.type) {
				case(ResizeEvent.RESIZE):
					//resizeStarling();
					break;
					
				default:
					break;
			}
		}
		
		
		/**
		 * Called when Starling is ready. Override it and use it as entry point !
		 */
		protected function start():void {
			
		}
		
		/**
		 * Add new StarlingComponent.
		 * 
		 * @param	componentClass : StarlingComponent
		 * @param	modelClass : Model of the component
		 * @param	commandClass : Command of the component
		 */
		public final function addStarlingComponent(componentClass:Class, modelClass:Class, commandClass:Class):void {
			if (!componentClass || !modelClass || !commandClass) throw new FrameworkError(FrameworkError.E_COMPONENT_ADD);
			
			var component:StarlingComponent;
			var model:AbstractModel;
			var command:AbstractCommand;
			
			try {
				component = new componentClass();
				model = new modelClass();
				command = new commandClass();
				
				model.component = component;
				
				mapModelData(model as IModel);
				
				command.model = (model as IModel);
				
				component.index = _numStarlingComponents;
				component.context = this;
				component.model = (model as IModel);
				component.command = (command as ICommand);
				
				component.build();
				
				_starlingSomponents[component.id] = component;
				
				_numStarlingComponents++;
			} catch (er:Error) {
				trace(er.getStackTrace());
				//throw er;
			}
		}
		
		/**
		 * Remove StarlingComponent.
		 * 
		 * @param id : Name of the StarlingComponent in order to find it in the stack.
		 */
		public final function removeStarlingComponent(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_COMPONENT_REMOVE);
			
			var component:StarlingComponent;
			
			try {
				if (_starlingSomponents[id] != undefined) {
					component = _starlingSomponents[id] as StarlingComponent;
					component.destroy();
					component = null;
					
					_starlingSomponents[id] = undefined;
					delete _starlingSomponents[id];
					
					_numStarlingComponents--;
				}
			} catch (er:Error) {
				throw er;
			}
			
			if (_numStarlingComponents > 0) reorderStarlingComponentStack();
		}
		
		/**
		 * Get StarlingComponent.
		 * 
		 * @param id : Name of the StarlingComponent in order to find it in the stack.
		 * @return  the StarlingComponent corresponding to the ID or null if ID ins't exist in the stack
		 */
		public final function getStarlingComponent(id:String):StarlingComponent {
			if (!id) throw new FrameworkError(FrameworkError.E_COMPONENT_GET);
			
			var component:StarlingComponent = null;
			
			if (_starlingSomponents[id] != undefined) component = (_starlingSomponents[id] as StarlingComponent);
			
			return component;
		}
		
		/**
		 * Test if StarlingComponent exists.
		 * 
		 * @param	id : Name of the StarlingComponent in order to find it in the stack.
		 * @return
		 */
		public final function hasStarlingComponent(id:String):Boolean {
			if (!id) throw new FrameworkError(FrameworkError.E_COMPONENT_HAS);
			
			return _starlingSomponents[id] != undefined;
		}
		
		/**
		 * Swap Components (z-order in stack).
		 * 
		 * @param	comp1	The index position of the first StarlingComponent.
		 * @param	comp2	The index position of the second StarlingComponent.
		 */
		public final function swapStarlingComponents(comp1:StarlingComponent, comp2:StarlingComponent):void {
			if (!comp1 || !comp2) return;
			
			var index1:int = comp1.index;
			var index2:int = comp2.index;
			
			comp1.index = index2;
			comp2.index = index1;
			
			_starlingRoot.swapChildren(comp1.viewPort, comp2.viewPort);
		}
		
		/**
		 * Add new Manager.
		 * 
		 * @param	managerClass : AbstractManager
		 * @param	id : ID of the Manager.
		 */
		public final function addManager(managerClass:Class, id:String):void {
			if (!managerClass) throw new FrameworkError(FrameworkError.E_MANAGER_ADD);
			
			var manager:AbstractManager;
			
			try {
				manager = new managerClass();
				manager.id = id;
				manager.context = this;
				
				manager.build();
				
				_managers[manager.id] = manager;
				
				_numManagers++;
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Remove Manager.
		 * 
		 * @param id : Name of the Manager in order to find it in the stack.
		 */
		public final function removeManager(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_MANAGER_REMOVE);
			
			var manager:AbstractManager = null;
			
			try {
				if (_managers[id] != undefined) {
					manager = (_managers[id] as AbstractManager);
					manager.destroy();
					manager = null;
					
					_managers[id] = undefined;
					delete _managers[id];
					
					_numManagers--;
				}
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Get Manager.
		 * 
		 * @param	id : Name of the Manager in order to find it in the stack.
		 * 
		 * @return the Manager corresponding to the ID or null if ID ins't exist in the stack.
		 */
		public final function getManager(id:String):AbstractManager {
			if (!id) throw new FrameworkError(FrameworkError.E_MANAGER_GET);
			
			var manager:AbstractManager = null;
			
			if (_managers[id] != undefined) manager = (_managers[id] as AbstractManager);
			
			return manager;
		}
		
		/**
		 * Get Debug version of Context.
		 * 
		 * @return
		 */
		public function debug():String {
			var t:String = '';
			var a:Array;
			var o:Object;
			
			if (!this.isContextSetup) return "Can't get debug information ! Setup method don't called !";
			
			t += '[[ ' + this.name + ' DEBUG CONTEXT ]]';
			t += '\n';
			t += 'Width : ' + this.contextWidth;
			t += '\n';
			t += 'Height : ' + this.contextHeight;
			t += '\n';
			t += 'Mode : ' + this.mode;
			t += '\n';
			t += 'StarlingComponents : ' + _numStarlingComponents;
			t += '\n';
			
			if (_numStarlingComponents > 0) {
				a = parseDictionary(_starlingSomponents);
				
				for (o in a) {
					t += '----- ' + a[o];
					t += '\n';
				}
			}
			
			t += 'Managers : ' + _numManagers;
			t += '\n';
			
			if (_numManagers > 0) {
				a = parseDictionary(_managers);
				
				for (o in a) {
					t += '----- ' + a[o];
					t += '\n';
				}
			}
			
			t += 'RenderEngine : ' + this.renderEngine.state;
			
			return t;
		}
		
		/**
		 * Called when key is released.
		 * 
		 * @param	keyCode
		 */
		override protected function onReleaseKeyInput(keyCode:uint):void {
			
		}
		
		/**
		 * Called by InteractiveContext during resizing.
		 */
		override protected function resize():void {
			resizeAllStarlingComponents();
		}
		
		/**
		 * When FlashPlayer receive focus.
		 */
		override protected function focus():void {
			if (_starling && !_starling.isStarted) _starling.start();
		}
		
		/**
		 * When FlashPlayer lose focus.
		 */
		override protected function unfocus():void {
			if (_starling && _starling.isStarted)_starling.stop();
		}
		
		/**
		 * Setup the context. Must be overrided and called at first.
		 */
		override public function setup():void {
			init();
			setupStarlingComponentStack();
			setupManagerStack();
			
			super.setup();
			
			setupStarling();
		}
		
		/**
		 * Destroy the context. Must be overrided and called at end.
		 */
		override public function destroy():void {
			disposeStarlingComponentStack();
			destroyStarlingComponentStack();
			disposeManagerStack();
			destroyManagerStack();
			destroyStarling();
			
			super.destroy();
			
			_starlingSomponents = null;
			_managers = null;
			_numStarlingComponents = 0;
			_numManagers = 0;
			_handleLostContext = false;
		}
		
		
		/**
		 * @private
		 */
		public function get numStarlingComponents():int {
			return _numStarlingComponents;
		}
		
		/**
		 * @private
		 */
		public function get numManagers():int {
			return _numManagers;
		}
		
		/**
		 * @private
		 */
		public function get handleLostContext():Boolean {
			return _handleLostContext;
		}
		
		/**
		 * @private
		 */
		public function set handleLostContext(value:Boolean):void {
			if (value != _handleLostContext) {
				_handleLostContext = value;
				
				Starling.handleLostContext = _handleLostContext;
			}
		}
		
		/**
		 * @private
		 */
		public function get starling():Starling {
			return _starling;
		}
		
		/**
		 * @private
		 */
		public function get starlingStage():Stage {
			return _starlingStage;
		}
		
		/**
		 * @private
		 */
		public function get starlingRoot():StarlingRootClass {
			return _starlingRoot;
		}
	}
}