package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.FlyingMan;
	import gshah.IGshahAnimationController;
	import gshah.intros.logos.FlyingManLogo1;
	import gshah.intros.texts.GshahTextFont;
	
	public class FlyingManAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function FlyingManAnimationController()
		{
			_content=new FlyingMan(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR SLOGAN HERE','Myriad Pro Bold',40,0xFFFFFF)];
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
				for (var j:int = 0; j < content.numChildren; j++) 
				{
					for (var i:int = 0; i < Object(content.getChildAt(j)).numChildren; i++) 
					{
						if(Object(content.getChildAt(j)).getChildAt(i)!=null&&Object(content.getChildAt(j)).getChildAt(i) is FlyingManLogo1)
						{
							var bitmap:Bitmap=new Bitmap(value.bitmapData);
							var nWidth:Number=314.95;
							var nHeight:Number=314.95;
							var nX:Number=-2.45;
							var nY:Number=-258.45;
							var scale:Number=Math.min(nWidth/bitmap.bitmapData.width,nHeight/bitmap.bitmapData.height);
							bitmap.width=bitmap.bitmapData.width*scale;
							bitmap.height=bitmap.bitmapData.height*scale;
							nX+=(nWidth-bitmap.width)/2;
							nY+=(nHeight-bitmap.height)/2;
							bitmap.x=nX;
							bitmap.y=nY;
							(Object(content.getChildAt(j)).getChildAt(i) as MovieClip).removeChildren();
							(Object(content.getChildAt(j)).getChildAt(i) as MovieClip).addChild(bitmap);
							break;
						}
						
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
			return 1;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}