package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.RocketLaunch;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	import gshah.intros.logos.RocketLaunchLogo1;
	
	public class RocketLaunchAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function RocketLaunchAnimationController()
		{
			_content=new RocketLaunch(this);
		}
		private var texts:Array=[new GshahTextFont('www.slogan.com','Helsinki Regular',40,0xFFFFFF), new GshahTextFont('YOUR LOGO','Helsinki Bold',96,0xFFFFFF)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
		}
		private var logos:Array=[null, null];
		public function setLogo(value:Bitmap, num:int):void
		{
			logos[num]=value;
			if(num==0&&_content!=null)
			{
				for (var j:int = 0; j < content.numChildren; j++) 
				{
					if(Object(content.getChildAt(j)).hasOwnProperty('numChildren'))
					{
						for (var i:int = 0; i < Object(content.getChildAt(j)).numChildren; i++) 
						{
							if(Object(content.getChildAt(j)).getChildAt(i)!=null&&Object(content.getChildAt(j)).getChildAt(i) is RocketLaunchLogo1)
							{
								var bitmap:Bitmap=new Bitmap(value.bitmapData);
								var nWidth:Number=106.6;
								var nHeight:Number=92.8;
								var nX:Number=0;
								var nY:Number=0;
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
			return 2;
		}
		public function get numLogos():int
		{
			return 2;
		}
	}
}