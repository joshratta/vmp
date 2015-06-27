package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro7aAnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro7aAnimationController()
		{
			_content=new Outro7a(this);
		}
		private var texts:Array=[new GshahTextFont('NEXT VIDEO','Lato Hairline',58,0x5C4B51),new GshahTextFont('twitter.com/youraccount','Open Sans Regular',30,0xFFFFFF),
		new GshahTextFont('youtube.com/channel/yourchannel','Myriad Pro Regular',30,0xFFFFFF),new GshahTextFont('yoursite.com','Open Sans Regular',38,0xFFFFFF),
		new GshahTextFont('facebook.com/yourpage','Open Sans Regular',30,0xFFFFFF),new GshahTextFont('SUBSCRIBE','Open Sans Semibold',32,0xFFFFFF)];
		
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;		
			
		}
		private var logos:Array=[null,null,null,null,null];
		public function setLogo(value:Bitmap, num:int):void
		{
			logos[num]=value;
			
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
			return 6;
		}
		public function get numLogos():int
		{
			return 1;
		}
		public function get videoDatas():Array
		{
			return [new OutroVideoData(245.1-97.85,456.3-247.7,983.1,553,25)];
		}
	}
}