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
	
	import starling.display.Image;
	import starling.display.Quad;
	
	
	/**
	 * StarlingGraphicsTools
	 * 
	 * @author David Massenot
	 */
	public class StarlingGraphicsTools {
		
		
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
		public static function drawCircle(radius:int, color:uint, scale:Number = 1):Image {
			var bmp:Bitmap;
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(radius, radius, radius);
			shape.graphics.endFill();
			
			bmpData = new BitmapData(radius * 2, radius * 2, true, 0);
			bmpData.draw(shape, new Matrix());
			
			bmp = new Bitmap(bmpData, 'auto', true);
			
			return Image.fromBitmap(bmp, true, scale);
		}
		
		/**
		 * Draw rounded rectangle.
		 * 
		 * @param	width
		 * @param	height
		 * @param	radius
		 * @param	color
		 * @param	scale
		 * @return
		 */
		public static function drawRoundRect(width:int, height:int, radius:Number, color:uint, scale:Number = 1, alpha:Number = 1):Image {
			var bmp:Bitmap;
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRoundRect(0, 0, width * scale, height * scale, radius * scale, radius * scale);
			shape.graphics.endFill();
			
			bmpData = new BitmapData(width * scale, height * scale, true, 0);
			bmpData.draw(shape, new Matrix(), null, null, null, true);
			
			bmp = new Bitmap(bmpData, 'auto', true);
			
			return Image.fromBitmap(bmp, true, scale);
		}
		
		/**
		 * Draw line rounded rectangle.
		 * 
		 * @param	width
		 * @param	height
		 * @param	thickness
		 * @param	radius
		 * @param	color
		 * @param	scale
		 * @return
		 */
		public static function drawLineRoundRect(width:int, height:int, thickness:int, radius:Number, color:uint, scale:Number = 1):Image {
			var bmp:Bitmap;
			var bmpData:BitmapData;
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(color, 0);
			shape.graphics.lineStyle(thickness, color, 1, true, 'normal', CapsStyle.ROUND, null, 10);
			shape.graphics.drawRoundRect(0, 0, width * scale, height * scale, radius * scale, radius * scale);
			shape.graphics.endFill();
			
			bmpData = new BitmapData((width + thickness) * scale, (height + thickness) * scale, true, 0);
			bmpData.draw(shape, new Matrix(), null, null, null, true);
			
			bmp = new Bitmap(bmpData, 'auto', true);
			
			return Image.fromBitmap(bmp, true, scale);
		}
	}
}