package gshah.outros.logos {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	
	public class OutroMainLogo extends MovieClip {
		
		public static var dafaultBitmap:Bitmap;
		public static var defaultPath:String;
		
		public function OutroMainLogo() {
			if(dafaultBitmap!=null)
			{
				var bitmap:Bitmap=new Bitmap(dafaultBitmap.bitmapData);
				var scale:Number=Math.min(150/bitmap.bitmapData.width,150/bitmap.bitmapData.height);
				bitmap.width=bitmap.bitmapData.width*scale;
				bitmap.height=bitmap.bitmapData.height*scale;
				bitmap.x=(150-bitmap.width)/2;
				bitmap.y=(150-bitmap.height)/2;
				this.removeChildren();
				graphics.clear();
				this.addChild(bitmap);
			}
				
		}
	}
	
}
