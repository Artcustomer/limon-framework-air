/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.loaders.assets.medias {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import artcustomer.framework.loaders.assets.consts.AssetType;
	
	
	/**
	 * AnimationAsset
	 * 
	 * @author David Massenot
	 */
	public class AnimationAsset extends AbstractLoadableAsset {
		private var _loader:Loader;
		private var _urlRequest:URLRequest;
		
		
		/**
		 * Constructor
		 */
		public function AnimationAsset() {
			super();
			
			_type = AssetType.ANIMATION;
			
			setupLoader();
		}
		
		//---------------------------------------------------------------------
		//  Loader
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupLoader():void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleErrorLoader, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgressLoader, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleCompleteLoader, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function destroyLoader():void {
			if (_loader) {
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorLoader);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleProgressLoader);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleCompleteLoader);
				_loader = null;
			}
		}
		
		/**
		 * @private
		 */
		private function startLoader():void {
			if (_loader) _loader.load(_urlRequest);
		}
		
		/**
		 * @private
		 */
		private function closeLoader():void {
			if (_loader) _loader.close();
		}
		
		//---------------------------------------------------------------------
		//  URLRequest
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setupURLRequest():void {
			_urlRequest = new URLRequest(_source);
		}
		
		/**
		 * @private
		 */
		private function destroyURLRequest():void {
			_urlRequest = null;
		}
		
		//---------------------------------------------------------------------
		//  Listeners
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handleErrorLoader(e:IOErrorEvent):void {
			_error = e.text;
			
			super.onError();
		}
		
		/**
		 * @private
		 */
		private function handleProgressLoader(e:ProgressEvent):void {
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			_progress = _bytesLoaded / _bytesTotal;
			
			this.dispatchEvent(e.clone());
		}
		
		/**
		 * @private
		 */
		private function handleCompleteLoader(e:Event):void {
			_bytesLoaded = _bytesTotal;
			
			_data = e.target.content;
			//_bytes = e.target.bytes;
			
			super.onComplete();
		}
		
		
		/**
		 * Start loading.
		 */
		override public function load():void {
			super.load();
			
			setupURLRequest();
			startLoader();
		}
		
		/**
		 * Close loading.
		 */
		override public function close():void {
			if (!_isLoading) {
				if (_isOpenStream) {
					try {
						closeLoader();
					} catch (er:Error) {
						
					}
				}
				
				destroyURLRequest();
				destroyLoader();
			}
			
			super.close();
		}
		
		/**
		 * Destructor
		 */
		override public function destroy():void {
			destroyURLRequest();
			destroyLoader();
			
			super.destroy();
		}
	}
}