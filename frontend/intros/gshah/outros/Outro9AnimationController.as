package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.outros.logos.Outro9Logo3;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro9AnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro9AnimationController()
		{
			_content=new Outro9(this);
		}
		private var texts:Array=[new GshahTextFont('Previous video','Open Sans Regular',58,0x064379),new GshahTextFont('Next video','Open Sans Regular',58,0x064379),
		new GshahTextFont('yourvideos.com','Myriad Pro Regular',32,0x09437A),new GshahTextFont('facebook.com/yourvideos','Myriad Pro Regular',32,0x09437A),new GshahTextFont('twitter.com/yourvideos','Myriad Pro Regular',32,0x09437A)];
		
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;		
			
		}
		private var logos:Array=[null,null,null,null,null];
		public function setLogo(value:Bitmap, num:int):void
		{
			logos[num]=value;
			if(num==2&&_content!=null)
			{

					for (var i:int = 0; i < content.numChildren; i++) 
					{
						if(content.getChildAt(i)!=null&&content.getChildAt(i) is Outro9Logo3)
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
			return 5;
		}
		public function get numLogos():int
		{
			return 3;
		}
		public function get videoDatas():Array
		{
			return [new OutroVideoData(1284.4-97.85,133.35-55,640.5,360.3,61),
			new OutroVideoData(1284.4-97.85,643.3-55,640.5,360.3,61),
			new OutroVideoData(91.95,563.9,778.35,437.85,30)];
		}
	}
}