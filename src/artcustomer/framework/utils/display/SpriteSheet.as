/*
 * Copyright (c) 2013 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import artcustomer.framework.loaders.assets.AssetsLoader;
	import artcustomer.framework.utils.tools.FileTools;
	
	
	/**
	 * SpriteSheet
	 * 
	 * @author David Massenot
	 */
	public class SpriteSheet {
		
		
		/**
		 * Constructor
		 */
		public function SpriteSheet() {
			
		}
		
		
		/**
		 * Get Bitmap from XML SpriteSheet.
		 * 
		 * @param	bitmap
		 * @param	xml
		 * @param	name
		 * @return
		 */
		public static function getBitmap(bitmapAssets:Bitmap, xmlAssets:XML, name:String):Bitmap {
			var nameTexture:String;
			var bitmap:Bitmap;
			
			for each (var subTexture:XML in xmlAssets.SubTexture) {
				nameTexture = subTexture.attribute('name');
				
				if (nameTexture == name) {
					var x:Number = parseFloat(subTexture.attribute('x'));
					var y:Number = parseFloat(subTexture.attribute('y'));
					var width:Number = parseFloat(subTexture.attribute('width'));
					var height:Number = parseFloat(subTexture.attribute('height'));
					var frameX:Number = parseFloat(subTexture.attribute('frameX'));
					var frameY:Number = parseFloat(subTexture.attribute('frameY'));
					var frameWidth:Number = parseFloat(subTexture.attribute('frameWidth'));
					var frameHeight:Number = parseFloat(subTexture.attribute('frameHeight'));
					
					break;
				}
			}
			
			bitmap = new Bitmap(new BitmapData(width, height));
			bitmap.bitmapData.copyPixels(bitmapAssets.bitmapData, new Rectangle(x, y, width, height), new Point());
			
			return bitmap;
		}
		
		
		/**
		 * Get Bitmap from XML SpriteSheet loaded by AssetsLoader.
		 * 
		 * @param	spriteSheetPNG
		 * @param	spriteSheetXML
		 * @param	name
		 * @param	scale
		 * @return
		 */
		public static function getBitmapFromAssetsLoader(spriteSheetPNG:String, spriteSheetXML:String, name:String, scale:Number = 0):Bitmap {
			if (scale > 0) {
				spriteSheetPNG = FileTools.escapeScaleFromFileName(spriteSheetPNG, scale);
				spriteSheetXML = FileTools.escapeScaleFromFileName(spriteSheetXML, scale);
			}
			
			var assetsLoader:AssetsLoader = AssetsLoader.getInstance();
			var nameTexture:String;
			var bitmap:Bitmap;
			var bitmapAssets:Bitmap = assetsLoader.getAssetByFile(spriteSheetPNG).data;
			var xmlAssets:XML = assetsLoader.getAssetByFile(spriteSheetXML).bytes;
			
			for each (var subTexture:XML in xmlAssets.SubTexture) {
				nameTexture = subTexture.attribute('name');
				
				if (nameTexture == name) {
					var x:Number = parseFloat(subTexture.attribute('x'));
					var y:Number = parseFloat(subTexture.attribute('y'));
					var width:Number = parseFloat(subTexture.attribute('width'));
					var height:Number = parseFloat(subTexture.attribute('height'));
					var frameX:Number = parseFloat(subTexture.attribute('frameX'));
					var frameY:Number = parseFloat(subTexture.attribute('frameY'));
					var frameWidth:Number = parseFloat(subTexture.attribute('frameWidth'));
					var frameHeight:Number = parseFloat(subTexture.attribute('frameHeight'));
					
					break;
				}
			}
			
			bitmap = new Bitmap(new BitmapData(width, height));
			bitmap.bitmapData.copyPixels(bitmapAssets.bitmapData, new Rectangle(x, y, width, height), new Point());
			
			return bitmap;
		}
	}
}