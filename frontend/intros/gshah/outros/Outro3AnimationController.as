package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.outros.logos.Outro3Logo4;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro3AnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro3AnimationController()
		{
			_content=new Outro3(this);
		}
		private var texts:Array=[new GshahTextFont('Title for first preview','Myriad Pro Regular',44,0xFFFFFF),new GshahTextFont('Title for second preview','Myriad Pro Regular',44,0xFFFFFF),
		new GshahTextFont('Title for third preview','Myriad Pro Regular',44,0xFFFFFF),new GshahTextFont('Our most  popular video in this week','Myriad Pro Regular',44,0xFFFFFF),
		new GshahTextFont('Join us for more','Myriad Pro Regular',44,0xFFFFFF),new GshahTextFont('videos like this','Myriad Pro Regular',44,0xFFFFFF),
		new GshahTextFont('yoursite.com','Myriad Pro Regular',30,0xFFFFFF),new GshahTextFont('More videos from our channel','Myriad Pro Regular',44,0xFFFFFF),new GshahTextFont('Subscribe','Lato Semibold',44,0xFFFFFF)];
		
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;		
			
		}
		private var logos:Array=[null,null,null,null];
		public function setLogo(value:Bitmap, num:int):void
		{
			logos[num]=value;
			if(num==3&&_content!=null)
			{

					for (var i:int = 0; i < content.numChildren; i++) 
					{
						if(content.getChildAt(i)!=null&&content.getChildAt(i) is Outro3Logo4)
						{
							var bitmap:Bitmap=new Bitmap(value.bitmapData);
							var nWidth:Number=913.65;
							var nHeight:Number=513.95;
							var nX:Number=0
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
			return 1920;
		}
		public function get contentHeight():Number
		{
			return 1080;
		}
		public function get numTexts():int
		{
			return 9;
		}
		public function get numLogos():int
		{
			return 4;
		}
		public function get videoDatas():Array
		{
			return [new OutroVideoData(125.55,688.3,444.8,250.2,78),
			new OutroVideoData(735.95,688.3,444.8,250.2,80),
			new OutroVideoData(1356.3,688.3,444.8,250.2,82),
			new OutroVideoData(563.25,50.35,778.35,437.85,15)];
		}
	}
}