/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.engines.component {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import artcustomer.framework.context.*;
	import artcustomer.framework.engines.component.*;
	import artcustomer.framework.core.*;
	import artcustomer.framework.events.*;
	import artcustomer.framework.errors.*;
	import artcustomer.framework.context.StarlingContext;
	import artcustomer.framework.core.AbstractStarlingView;
	
	import starling.display.Sprite;
	
	[Event(name = "componentBuild", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentInit", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentDestroy", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentAdd", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	[Event(name = "componentRemove", type = "artcustomer.framework.events.FrameworkComponentEvent")]
	
	
	/**
	 * StarlingComponent
	 * 
	 * @author David Massenot
	 */
	public class StarlingComponent extends ViewMediator {
		private static const FULL_CLASS_NAME:String = 'artcustomer.framework.engines.component::StarlingComponent';
		
		private var _viewPort:Sprite;
		
		
		/**
		 * Constructor : Create a StarlingComponent (called by StarlingContext)
		 */
		public function StarlingComponent() {
			super();
			
			if (getQualifiedClassName(this) == FULL_CLASS_NAME) throw new IllegalError(IllegalError.E_COMPONENT_CONSTRUCTOR);
		}
		
		//---------------------------------------------------------------------
		//  ViewPort
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupViewPort():void {
			_viewPort = new Sprite();
		}
		
		/**
		 * @private
		 */
		private function destroyViewPort():void {
			if (_viewPort) _viewPort = null;
		}
		
		/**
		 * Called by Mediator when a view is registered.
		 * 
		 * @param	view
		 */
		override protected function onViewRegistered(view:IView):void {
			(view as AbstractStarlingView).objectParent = _viewPort;
		}
		
		
		/**
		 * Entry point of the Component. Must be overrided and called at first in child.
		 */
		override public function build():void {
			setupViewPort();
			
			super.build();
		}
		
		/**
		 * Destroy Component. Must be overrided and called at last in child.
		 */
		override public function destroy():void {
			remove();
			destroyViewPort();
			
			super.destroy();
		}
		
		/**
		 * Add Viewport on ContextView.
		 */
		public function add():void {
			if (!(this.context.instance as StarlingContext).starlingRoot.contains(_viewPort)) (this.context.instance as StarlingContext).starlingRoot.addChild(_viewPort);
		}
		
		/**
		 * Remove Viewport from ContextView.
		 */
		public function remove():void {
			if ((this.context.instance as StarlingContext).starlingRoot.contains(_viewPort)) (this.context.instance as StarlingContext).starlingRoot.removeChild(_viewPort);
		}
		
		/**
		 * Swap Views (z-order in stack).
		 * 
		 * @param	view1	The index position of the first IView.
		 * @param	view2	The index position of the second IView.
		 */
		override public function swapViews(view1:IView, view2:IView):void {
			super.swapViews(view1, view2);
			
			_viewPort.swapChildren((view1 as AbstractStarlingView).viewContainer, (view1 as AbstractStarlingView).viewContainer);
		}
		
		
		/**
		 * @private
		 */
		public function get viewPort():Sprite {
			return _viewPort;
		}
	}
}