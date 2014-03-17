/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.display.starling.graphics {
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	
	import starling.display.*;
	import starling.textures.Texture;
	
	
	/**
	 * StarlingGraphicsTools
	 * 
	 * @author David Massenot
	 */
	public class StarlingGraphicsTools {
		
		
		/**
		 * Draw rectangle.
		 * 
		 * @param	radius
		 * @param	color
		 * @param	scale
		 * @return
		 */
		public static function drawRect(width:int, height:int, color:uint, scale:Number = 1):Texture {
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0, 0, width * scale, height * scale);
			shape.graphics.endFill();
			
			bmpData = new BitmapData(width * scale, height * scale, true, 0);
			bmpData.draw(shape, new Matrix());
			
			return Texture.fromBitmapData(bmpData, true, false, scale);
		}
		
		/**
		 * Draw line.
		 * 
		 * @param	toX
		 * @param	toY
		 * @param	pX
		 * @param	pY
		 * @param	thickness
		 * @param	color
		 * @return
		 */
		public static function drawLine(toX:int, toY:int, pX:int = 0, pY:int = 0, thickness:Number = 1, color:uint = 0x000000):Quad {
			var line:Quad = new Quad(1, thickness, color);
			line.x = pX;
			line.y = pY;
			line.width = Math.round(Math.sqrt((toX * toX) + (toY * toY)));
			line.rotation = Math.atan2(toY, toX);
			
			return line;
		}
		
		/**
		 * Draw circle.
		 * 
		 * @param	radius
		 * @param	color
		 * @param	scale
		 * @return
		 */
		public static function drawCircle(radius:int, color:uint, scale:Number = 1):Texture {
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(radius, radius, radius);
			shape.graphics.endFill();
			
			bmpData = new BitmapData(radius * 2, radius * 2, true, 0);
			bmpData.draw(shape, new Matrix());
			
			return Texture.fromBitmapData(bmpData, true, false, scale);
		}
		
		/**
		 * Draw rounded rectangle.
		 * 
		 * @param	width
		 * @param	height
		 * @param	radius
		 * @param	color
		 * @param	alpha
		 * @param	scale
		 * @return
		 */
		public static function drawRoundRect(width:int, height:int, radius:Number, color:uint, scale:Number = 1, alpha:Number = 1):Texture {
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRoundRect(0, 0, width * scale, height * scale, radius * scale, radius * scale);
			shape.graphics.endFill();
			
			bmpData = new BitmapData(width * scale, height * scale, true, 0);
			bmpData.draw(shape, new Matrix(), null, null, null, true);
			
			return Texture.fromBitmapData(bmpData, true, false, scale);
		}
		
		/**
		 * Draw rounded rectangle with inner shadow
		 * 
		 * @param	width
		 * @param	height
		 * @param	radius
		 * @param	color
		 * @param	scale
		 * @param	alpha
		 * @param	shadowColor
		 * @return
		 */
		public static function drawRoundRectInnerShadow(width:int, height:int, radius:Number, color:uint, scale:Number = 1, alpha:Number = 1, shadowColor:uint = 0x000000):Texture {
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			var shadow:DropShadowFilter = new DropShadowFilter(4, 45, shadowColor, 1, 4, 4, 1, 1, true);
			
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRoundRect(0, 0, width * scale, height * scale, radius * scale, radius * scale);
			shape.graphics.endFill();
			shape.filters = [shadow];
			
			bmpData = new BitmapData(width * scale, (height + 0) * scale, true, 0);
			bmpData.draw(shape, new Matrix(), null, null, null, true);
			
			return Texture.fromBitmapData(bmpData, true, false, scale);
		}
		
		/**
		 * Draw line rounded rectangle.
		 * 
		 * @param	width
		 * @param	height
		 * @param	thickness
		 * @param	radius
		 * @param	fillColor
		 * @param	lineColor
		 * @param	fillAlpha
		 * @param	scale
		 * @return
		 */
		public static function drawLineRoundRect(width:int, height:int, thickness:int, radius:Number, fillColor:uint, lineColor:uint, fillAlpha:Number = 1, scale:Number = 1):Texture {
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(fillColor, fillAlpha);
			shape.graphics.lineStyle(thickness, lineColor, 1, true, 'normal', CapsStyle.ROUND, null, 10);
			shape.graphics.drawRoundRect(0, 0, width * scale, height * scale, radius * scale, radius * scale);
			shape.graphics.endFill();
			
			bmpData = new BitmapData((width + thickness) * scale, (height + thickness) * scale, true, 0);
			bmpData.draw(shape, new Matrix(), null, null, null, true);
			
			return Texture.fromBitmapData(bmpData, true, false, scale);
		}
		
		/**
		 * Draw shadow.
		 * 
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	alpha
		 * @param	scale
		 * @return
		 */
		public static function drawShadow(width:int, height:int, color:uint = 0x000000, alpha:Number = 1, scale:Number = 1):Texture {
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			var shadow:DropShadowFilter = new DropShadowFilter(0, 0, color, alpha, 4, 4, 1, 1, false, false, true);
			
			shape.graphics.beginFill(0x000000, 1);
			shape.graphics.drawRect(0, 0, width * scale, 3);
			shape.graphics.endFill();
			shape.filters = [shadow];
			
			bmpData = new BitmapData(width * scale, height * scale, true, 0);
			bmpData.draw(shape, new Matrix(), null, null, null, true);
			
			return Texture.fromBitmapData(bmpData, true, false, scale);
		}
	}
}