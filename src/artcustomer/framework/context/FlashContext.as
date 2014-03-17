/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.context {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.engines.component.*;
	import artcustomer.framework.engines.layers.*;
	import artcustomer.framework.engines.manager.*;
	import artcustomer.framework.core.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.utils.consts.*;
	
	
	/**
	 * FlashContext : Context of the application (using Flash display list)
	 * 
	 * @author David Massenot
	 */
	public class FlashContext extends BaseContext {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.context::Context';
		
		private var _components:Dictionary;
		private var _managers:Dictionary;
		private var _layer3ds:Dictionary;
		private var _layerVideos:Dictionary;
		
		private var _numComponents:int;
		private var _numManagers:int;
		private var _numLayer3ds:int;
		private var _numLayerVideos:int;
		
		private var _maxLayer3ds:int;
		private var _maxLayerVideos:int;
		
		private var _stackLayer3dID:int;
		private var _stackLayerVideosID:int;
		
		
		/**
		 * Constructor
		 */
		public function FlashContext() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_CONTEXT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  Initialize
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function init():void {
			_numComponents = 0;
			_numManagers = 0;
			_numLayer3ds = 0;
			_numLayerVideos = 0;
			_maxLayer3ds = this.stageReference.stage3Ds.length;
			_maxLayerVideos = this.stageReference.stageVideos.length;
		}
		
		//---------------------------------------------------------------------
		//  Components Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupComponentStack():void {
			if (!_components) _components = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyComponentStack():void {
			if (_components) _components = null;
		}
		
		/**
		 * @private
		 */
		private function disposeComponentStack():void {
			if (!_components) return;
			
			var id:String;
			
			for (id in _components) {
				this.removeComponent(id);
			}
		}
		
		/**
		 * @private
		 */
		private function resizeAllComponents():void {
			var id:String;
			var component:FlashComponent;
			
			for (id in _components) {
				component = _components[id] as FlashComponent;
				if (component) component.contextResize();
			}
		}
		
		/**
		 * @private
		 */
		private function reorderComponentStack():void {
			var i:int;
			var id:String;
			var component:FlashComponent;
			
			for (id in _components) {
				component = _components[id] as FlashComponent;
				
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
		//  Layer3Ds Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLayer3DStack():void {
			if (!_layer3ds) _layer3ds = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyLayer3DStack():void {
			if (_layer3ds) _layer3ds = null;
		}
		
		/**
		 * @private
		 */
		private function disposeLayer3DStack():void {
			if (!_layer3ds) return;
			
			var id:String;
			var layer3d:Layer3D;
			
			for (id in _layer3ds) {
				layer3d = _layer3ds[id] as Layer3D;
				
				this.removeLayer3D(layer3d);
			}
		}
		
		/**
		 * @private
		 */
		private function reorderLayer3DStack():void {
			if (!_layer3ds) return;
			
			var i:int;
			var id:String;
			var layer3d:Layer3D;
			
			for (id in _layer3ds) {
				layer3d = _layer3ds[id];
				
				if (layer3d) {
					layer3d.index = i;
					
					i++;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function renderLayer3DStack():void {
			if (!_layer3ds) return;
			
			var id:String;
			var layer:ILayer;
			
			for (id in _layer3ds) {
				layer = _layer3ds[id] as ILayer;
				if (layer) layer.onRender();
			}
		}
		
		/**
		 * @private
		 */
		private function resizeLayer3DStack():void {
			if (!_layer3ds) return;
			
			var id:String;
			var layer:ILayer;
			
			for (id in _layer3ds) {
				layer = _layer3ds[id] as ILayer;
				if (layer) layer.onResize();
			}
		}
		
		//---------------------------------------------------------------------
		//  LayerVideos Stack
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLayerVideoStack():void {
			if (!_layerVideos) _layerVideos = new Dictionary();
		}
		
		/**
		 * @private
		 */
		private function destroyLayerVideoStack():void {
			if (_layerVideos) _layerVideos = null;
		}
		
		/**
		 * @private
		 */
		private function disposeLayerVideoStack():void {
			if (!_layerVideos) return;
			
			var id:String;
			var layervideo:LayerVideo;
			
			for (id in _layerVideos) {
				layervideo = _layerVideos[id] as LayerVideo;
				
				this.removeLayerVideo(layervideo);
			}
		}
		
		/**
		 * @private
		 */
		private function reorderLayerVideoStack():void {
			if (!_layerVideos) return;
			
			var i:int;
			var id:String;
			var layervideo:LayerVideo;
			
			for (id in _layerVideos) {
				layervideo = _layerVideos[id];
				
				if (layervideo) {
					layervideo.index = i;
					
					i++;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function renderLayerVideoStack():void {
			if (!_layerVideos) return;
			
			var id:String;
			var layer:ILayer;
			
			for (id in _layerVideos) {
				layer = _layerVideos[id] as ILayer;
				if (layer) layer.onRender();
			}
		}
		
		/**
		 * @private
		 */
		private function resizeLayerVideoStack():void {
			if (!_layerVideos) return;
			
			var id:String;
			var layer:ILayer;
			
			for (id in _layerVideos) {
				layer = _layerVideos[id] as ILayer;
				if (layer) layer.onResize();
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
		
		
		/**
		 * Add new FlashComponent.
		 * 
		 * @param	componentClass : FlashComponent
		 * @param	modelClass : Model of the component
		 * @param	commandClass : Command of the component
		 */
		public final function addComponent(componentClass:Class, modelClass:Class, commandClass:Class):void {
			if (!componentClass || !modelClass || !commandClass) throw new FrameworkError(FrameworkError.E_COMPONENT_ADD);
			
			var component:FlashComponent;
			var model:AbstractModel;
			var command:AbstractCommand;
			
			try {
				component = new componentClass();
				model = new modelClass();
				command = new commandClass();
				
				model.component = component;
				
				mapModelData(model as IModel);
				
				command.model = (model as IModel);
				
				component.index = _numComponents;
				component.context = this;
				component.model = model as IModel;
				component.command = command as ICommand;
				
				component.build();
				
				_components[component.id] = component;
				
				_numComponents++;
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Remove FlashComponent.
		 * 
		 * @param id : Name of the Component in order to find it in the stack.
		 */
		public final function removeComponent(id:String):void {
			if (!id) throw new FrameworkError(FrameworkError.E_COMPONENT_REMOVE);
			
			var component:FlashComponent;
			
			try {
				if (_components[id] != undefined) {
					component = _components[id] as FlashComponent;
					component.destroy();
					component = null;
					
					_components[id] = undefined;
					delete _components[id];
					
					_numComponents--;
				}
			} catch (er:Error) {
				throw er;
			}
			
			if (_numComponents > 0) reorderComponentStack();
		}
		
		/**
		 * Get FlashComponent.
		 * 
		 * @param id : Name of the FlashComponent in order to find it in the stack.
		 * @return  the FlashComponent corresponding to the ID or null if ID ins't exist in the stack
		 */
		public final function getComponent(id:String):FlashComponent {
			if (!id) throw new FrameworkError(FrameworkError.E_COMPONENT_GET);
			
			var component:FlashComponent;
			
			if (_components[id] != undefined) component = (_components[id] as FlashComponent);
			
			return component;
		}
		
		/**
		 * Test if FlashComponent exists.
		 * 
		 * @param	id : Name of the Component in order to find it in the stack.
		 * @return
		 */
		public final function hasComponent(id:String):Boolean {
			if (!id) throw new FrameworkError(FrameworkError.E_COMPONENT_HAS);
			
			return _components[id] != undefined;
		}
		
		/**
		 * Swap FlashComponents (z-order in stack).
		 * 
		 * @param	comp1	The index position of the first Component.
		 * @param	comp2	The index position of the second Component.
		 */
		public final function swapComponents(comp1:FlashComponent, comp2:FlashComponent):void {
			if (!comp1 || !comp2) return;
			
			var index1:int = comp1.index;
			var index2:int = comp2.index;
			
			comp1.index = index2;
			comp2.index = index1;
			
			this.contextView.swapChildren(comp1.viewPort, comp2.viewPort);
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
		 * Add Layer3D.
		 * 
		 * @param	context3dClass : Class of the instance of Layer3D.
		 * @return the instance created.
		 */
		public final function addLayer3D(context3dClass:Class):Layer3D {
			if (!context3dClass) throw new FrameworkError(FrameworkError.E_LAYER3D_ADD);
			if (_numLayer3ds >= _maxLayer3ds) throw new FrameworkError(FrameworkError.E_LAYER3D_OVERFLOW);
			
			var layer3d:Layer3D = null;
			
			try {
				layer3d = new context3dClass();
				layer3d.context = this;
				layer3d.id = _stackLayer3dID.toString();
				layer3d.index = _numLayer3ds;
				
				layer3d.setup();
				
				_layer3ds[layer3d.id] = layer3d;
				
				_numLayer3ds++;
				_stackLayer3dID++;
			} catch (er:Error) {
				throw er;
			}
			
			return layer3d;
		}
		
		/**
		 * Remove instance of Layer3D at index.
		 * 
		 * @param	index : index of the Layer3D in order to find it in the stack.
		 */
		public final function removeLayer3DAt(index:int):void {
			if (index < 0 || index >= _maxLayer3ds) throw new FrameworkError(FrameworkError.E_LAYER3D_REMOVE);
			
			var layer3d:Layer3D = this.getLayer3dAt(index);
			
			try {
				this.removeLayer3D(layer3d);
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Remove instance of Layer3D.
		 * 
		 * @param	layer3d : Instance of Layer3D
		 */
		public final function removeLayer3D(layer3d:Layer3D):void {
			if (!layer3d) return;
			
			var id:String = layer3d.id;
			
			layer3d.destroy();
			layer3d = null;
			
			_layer3ds[id] = undefined;
			delete _layer3ds[id];
			
			_numLayer3ds--;
			
			if (_numLayer3ds > 0) reorderLayer3DStack();
		}
		
		/**
		 * Get Layer3D.
		 * 
		 * @param	index : Index of the Layer3D in order to find it in the stack
		 * @return the Layer3D corresponding to the index or null if index ins't exist in the stack
		 */
		public final function getLayer3dAt(index:int):Layer3D {
			if (index < 0 || index >= _maxLayer3ds) throw new FrameworkError(FrameworkError.E_LAYER3D_GET);
			
			var id:String;
			var layer3d:Layer3D;
			
			for (id in _layer3ds) {
				layer3d = _layer3ds[id] as Layer3D;
				
				if (layer3d && layer3d.index == index) return layer3d;
			}
			
			return null;
		}
		
		/**
		 * Test Layer3D.
		 * 
		 * @param	index : Index of the Layer3D in order to find it in the stack.
		 * @return True if Layer3D exists / False if Layer3D isn't exists
		 */
		public final function hasLayer3dAt(index:int):Boolean {
			if (index < 0 || index >= _maxLayer3ds) return false;
			if (this.getLayer3dAt(index)) return true;
			
			return false;
		}
		
		/**
		 * Add LayerVideo.
		 * 
		 * @param	contextvideoClass : Class of the instance of LayerVideo.
		 * @return the instance created.
		 */
		public final function addLayerVideo(contextvideoClass:Class):LayerVideo {
			if (!contextvideoClass) throw new FrameworkError(FrameworkError.E_LAYERVIDEO_ADD);
			if (_numLayerVideos >= _maxLayerVideos) throw new FrameworkError(FrameworkError.E_LAYERVIDEO_OVERFLOW);
			
			var layervideo:LayerVideo = null;
			
			try {
				layervideo = new contextvideoClass();
				layervideo.context = this;
				layervideo.id = _stackLayerVideosID.toString();
				layervideo.index = _numLayerVideos;
				
				layervideo.setup();
				
				_layerVideos[layervideo.index.toString()] = layervideo;
				
				_numLayerVideos++;
				_stackLayerVideosID++;
			} catch (er:Error) {
				throw er;
			}
			
			return layervideo;
		}
		
		/**
		 * Remove instance of LayerVideo at index
		 * 
		 * @param	index : index of the LayerVideo in order to find it in the stack.
		 */
		public final function removeLayerVideoAt(index:int):void {
			if (index < 0 || index >= _maxLayerVideos) throw new FrameworkError(FrameworkError.E_LAYERVIDEO_REMOVE);
			
			var layervideo:LayerVideo = this.getLayerVideoAt(index);
			
			try {
				this.removeLayerVideo(layervideo);
			} catch (er:Error) {
				throw er;
			}
		}
		
		/**
		 * Remove instance of LayerVideo
		 * 
		 * @param	layervideo : Instance of LayerVideo
		 */
		public final function removeLayerVideo(layervideo:LayerVideo):void {
			if (!layervideo) return;
			
			var id:String = layervideo.id;
			
			layervideo.destroy();
			layervideo = null;
			
			_layerVideos[id] = undefined;
			delete _layerVideos[id];
			
			_numLayerVideos--;
			
			if (_numLayerVideos > 0) reorderLayerVideoStack();
		}
		
		/**
		 * Get LayerVideo.
		 * 
		 * @param	index : Index of the LayerVideo in order to find it in the stack
		 * @return the LayerVideo corresponding to the index or null if index ins't exist in the stack
		 */
		public final function getLayerVideoAt(index:int):LayerVideo {
			if (index < 0 || index >= _maxLayerVideos) throw new FrameworkError(FrameworkError.E_LAYERVIDEO_GET);
			
			var id:String;
			var layervideo:LayerVideo = null;
			
			for (id in _layerVideos) {
				layervideo = _layerVideos[id] as LayerVideo;
				
				if (layervideo && layervideo.index == index) return layervideo;
			}
			
			return null;
		}
		
		/**
		 * Test LayerVideo.
		 * 
		 * @param	index : Index of the LayerVideo in order to find it in the stack
		 * @return True if LayerVideo exists / False if LayerVideo isn't exists
		 */
		public final function hasLayerVideoAt(index:int):Boolean {
			if (index < 0 || index >= _maxLayerVideos) return false;
			if (this.getLayerVideoAt(index)) return true;
			
			return false;
		}
		
		/**
		 * Get Debug version of Context.
		 * 
		 * @return
		 */
		override public function debug():String {
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
			t += 'Components : ' + _numComponents;
			t += '\n';
			
			if (_numComponents > 0) {
				a = parseDictionary(_components);
				
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
			
			t += 'Layers3Ds : ' + _numLayer3ds;
			t += '\n';
			
			if (_numLayer3ds > 0) {
				a = parseDictionary(_layer3ds);
				
				for (o in a) {
					t += '----- ' + a[o];
					t += '\n';
				}
			}
			
			t += 'LayersVideos : ' + _numLayerVideos;
			t += '\n';
			
			if (_numLayerVideos > 0) {
				a = parseDictionary(_layerVideos);
				
				for (o in a) {
					t += '----- ' + a[o];
					t += '\n';
				}
			}
			
			t += 'RenderEngine : ' + this.renderEngine.state;
			
			return t;
		}
		
		/**
		 * Called by RenderEngine during rendering.
		 */
		override protected function render():void {
			renderLayer3DStack();
			renderLayerVideoStack();
		}
		
		/**
		 * Called by InteractiveContext during resizing.
		 */
		override protected function resize():void {
			resizeAllComponents();
			resizeLayerVideoStack();
			resizeLayer3DStack();
		}
		
		
		/**
		 * Setup the context. Must be overrided and called at first.
		 */
		override public function setup():void {
			init();
			setupComponentStack();
			setupManagerStack();
			setupLayer3DStack();
			setupLayerVideoStack();
			
			super.setup();
		}
		
		/**
		 * Destroy the context. Must be overrided and called at end.
		 */
		override public function destroy():void {
			disposeComponentStack();
			destroyComponentStack();
			disposeManagerStack();
			destroyManagerStack();
			disposeLayer3DStack();
			destroyLayer3DStack();
			disposeLayerVideoStack();
			destroyLayerVideoStack();
			
			super.destroy();
			
			_components = null;
			_managers = null;
			_layer3ds = null;
			_layerVideos = null;
			_numComponents = 0;
			_numManagers = 0;
			_numLayer3ds = 0;
			_numLayerVideos = 0;
			_maxLayer3ds = 0;
			_maxLayerVideos = 0;
			_stackLayer3dID = 0;
			_stackLayerVideosID = 0;
		}
		
		
		/**
		 * @private
		 */
		public function get numComponents():int {
			return _numComponents;
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
		public function get numLayer3ds():int {
			return _numLayer3ds;
		}
		
		/**
		 * @private
		 */
		public function get numLayerVideos():int {
			return _numLayerVideos;
		}
		
		/**
		 * @private
		 */
		public function get maxLayer3ds():int {
			return _maxLayer3ds;
		}
		
		/**
		 * @private
		 */
		public function get maxLayerVideos():int {
			return _maxLayerVideos;
		}
	}
}