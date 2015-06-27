package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.StickMan;
	import gshah.IGshahAnimationController;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import gshah.intros.logos.StickManLogo1;
	import gshah.intros.texts.GshahTextFont;
	
	public class StickManAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function StickManAnimationController()
		{
			_content=new StickMan(this);
		}
		private var texts:Array=[];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
			
		}
		private var logos:Array=[null];
		public function setLogo(value:Bitmap, num:int):void
		{
			logos[num]=value;
			if(num==0&&_content!=null)
			{
				for (var i:int = 0; i < content.numChildren; i++) 
				{
					if(content.getChildAt(i)!=null&&content.getChildAt(i) is StickManLogo1)
					{
						var bitmap:Bitmap=new Bitmap(value.bitmapData);
						var nWidth:Number=189.35;
						var nHeight:Number=34.3;
						var nX:Number=0;
						var nY:Number=0;
						var scale:Number=Math.min(nWidth/bitmap.bitmapData.width,nHeight/bitmap.bitmapData.height);
						bitmap.width=bitmap.bitmapData.width*scale;
						bitmap.height=bitmap.bitmapData.height*scale;
						nX+=(nWidth-bitmap.width)/2;
						nY+=(nHeight-bitmap.height)/2;
						bitmap.x=nX;
						bitmap.y=nY;
						(content.getChildAt(i) as MovieClip).removeChildren();
						(content.getChildAt(i) as MovieClip).addChild(bitmap);
						break;
					}
				}
			}
		}
		
		public function getText(num:int):GshahTextFont
		{
			return texts[num] as GshahTextFont;
		}
		public function getLogo(num:int):Bitmap
		{
			return logos[num] as Bitmap;
		}
		
		public function get content():MovieClip
		{
			return _content;
		}
		
		public function set content(value:MovieClip):void
		{
			_content=value;
		}
		
		public function get contentPaddingLeft():Number
		{
			return 0;
		}
		
		public function get contentPaddingTop():Number
		{
			return 0;
		}
		
		public function get contentWidth():Number
		{
			return 960;
		}
		public function get contentHeight():Number
		{
			return 540;
		}
		public function get numTexts():int
		{
			return 0;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}