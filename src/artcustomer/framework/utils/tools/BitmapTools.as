/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	/**
	 * BitmapTools : Tools for booleans.
	 * 
	 * @author David Massenot
	 */
	public class BitmapTools {
		public static const RESIZE_FROM_WIDTH:String = 'width';
		public static const RESIZE_FROM_HEIGHT:String = 'height';
		
		
		/**
		 * Create and return a new Bitmap that fit in bounds.
		 * 
		 * @param	bmpSrc
		 * @param	bounds
		 * @return
		 */
		public static function fit(bmpSrc:Bitmap, bounds:Rectangle):Bitmap {
			if (!bmpSrc) return null;
			if (!bounds) return bmpSrc;
			
			var width:int;
			var height:int;
			var nScaleX:Number;
			var nScaleY:Number;
			var nScale:Number;
			var matrix:Matrix = new Matrix();
			var bitmapdata:BitmapData;
			var factor:Number = Math.max(((bounds.width) / bmpSrc.width), ((bounds.height) / bmpSrc.height));
			
			width = bmpSrc.width * factor;
			height = bmpSrc.height * factor;
			
			nScaleX = (width / bmpSrc.width) * 100;
			nScaleY = (height / bmpSrc.height) * 100;
			nScale = Math.max(nScaleY, nScaleX) / 100;
			
			matrix.scale(nScale, nScale);
			
			bitmapdata = new BitmapData(width, height, true, 0);
			bitmapdata.draw(bmpSrc, matrix, null, null, null, true);
			
			return new Bitmap(bitmapdata, 'auto', true);
		}
		
		/**
		 * Resize bitmap image and return new Bitmap.
		 * 
		 * @param	bmpSrc
		 * @param	ratio
		 * @return
		 */
		public static function resize(bmpSrc:Bitmap, maxSize:int, ratio:String = RESIZE_FROM_WIDTH):Bitmap {
			if (!bmpSrc) return null;
			
			var width:int;
			var height:int;
			var nScaleX:Number;
			var nScaleY:Number;
			var nScale:Number;
			var matrix:Matrix = new Matrix();
			var bitmapdata:BitmapData;
			var factor:Number;
			
			switch (ratio) {
				case(RESIZE_FROM_WIDTH):
					factor = Math.min((maxSize / bmpSrc.width), 1);
					break;
					
				case(RESIZE_FROM_HEIGHT):
					factor = Math.min(1, (maxSize / bmpSrc.height));
					break;
					
				default:
					factor = 1;
					break;
			}
			
			width = bmpSrc.width * factor;
			height = bmpSrc.height * factor;
			
			nScaleX = (width / bmpSrc.width) * 100;
			nScaleY = (height / bmpSrc.height) * 100;
			nScale = Math.max(nScaleY, nScaleX) / 100;
			
			matrix.scale(nScale, nScale);
			
			bitmapdata = new BitmapData(width, height, true, 0);
			bitmapdata.draw(bmpSrc, matrix, null, null, null, true);
			
			return new Bitmap(bitmapdata, 'auto', true);
		}
		
		/**
		 * Rescale Bitmap.
		 * 
		 * @param	bmpSrc
		 * @param	scale
		 */
		public static function rescale(bmpSrc:Bitmap, scale:Number):void {
			if (!bmpSrc) return;
			
			var matrix:Matrix = bmpSrc.transform.matrix;
			
			matrix.scale(scale, scale);
			
			bmpSrc.transform.matrix = matrix;
		}
	}
}