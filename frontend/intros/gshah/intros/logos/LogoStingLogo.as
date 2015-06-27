package gshah.intros.logos {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.DisplayObjectContainer;
	
	
	public class LogoStingLogo extends MovieClip {
		
		
		public function LogoStingLogo(num:int=0, nWidth:Number=0,nHeight:Number=0,nX:Number=0,nY:Number=0, nTransperent:Boolean=true) {
			

			var p:DisplayObjectContainer=parent;
			while(p!=null&&!(p as Object).hasOwnProperty('controller'))
			{
				p=p.parent;
			}
			if(p!=null&&(p as Object).controller!=null)
			{
				var bitmap:Bitmap=(p as Object).controller.getLogo(num);
				if(bitmap!=null)
				{	
					bitmap=new Bitmap(bitmap.bitmapData);
					if(nWidth!=0&&nHeight!=0&&(nWidth!=bitmap.bitmapData.width||nHeight!=bitmap.bitmapData.height))
					{
						var scale:Number=Math.min(nWidth/bitmap.bitmapData.width,nHeight/bitmap.bitmapData.height);
						bitmap.width=bitmap.bitmapData.width*scale;
						bitmap.height=bitmap.bitmapData.height*scale;
						nX+=(nWidth-bitmap.width)/2;
						nY+=(nHeight-bitmap.height)/2;
						(p as Object).controller.setLogo(bitmap,num);
					}
					bitmap.x=nX;
					bitmap.y=nY;
					this.removeChildren();
					graphics.clear();
					this.addChild(bitmap);
					
					
					
					
				}
			}
		}
	}
	
}
