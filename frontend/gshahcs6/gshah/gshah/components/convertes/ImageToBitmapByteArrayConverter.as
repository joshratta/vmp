package gshah.components.convertes
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * This ImageToBitmapByteArrayConverter helps to convert
	 * <code>flash.display.BitmapData</code> to <code>flash.utils.ByteArray</code>
	 * 
	 */
	public class ImageToBitmapByteArrayConverter
	{	
		public static function convert(source:BitmapData):ByteArray
		{
			return source.getPixels(source.rect);
		}
		
		public static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData {
            scale = Math.abs(scale);
            var width:int = Math.round(bitmapData.width * scale);
            var height:int = Math.round(bitmapData.height * scale);
            var transparent:Boolean = bitmapData.transparent;
            var result:BitmapData = new BitmapData(width, height, transparent);
            var matrix:Matrix = new Matrix();
            matrix.scale(scale, scale);
            result.draw(bitmapData, matrix);
            return result;
        }
		
	}
}