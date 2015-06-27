package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro5AnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro5AnimationController()
		{
			_content=new Outro5(this);
		}
		private var texts:Array=[new GshahTextFont('Title for first preview','Myriad Pro Regular',44,0xFFFFFF),
		new GshahTextFont('Title for second preview','Myriad Pro Regular',44,0xFFFFFF),
		new GshahTextFont('Title for third preview','Myriad Pro Regular',44,0xFFFFFF),
		new GshahTextFont('yoursite.com','Myriad Pro Regular',30,0xFFFFFF),
		new GshahTextFont('www.facebook.com/yourpage','Myriad Pro Regular',30,0xFFFFFF),
		new GshahTextFont('www.twitter.com/youraccount','Myriad Pro Regular',30,0xFFFFFF),
		new GshahTextFont('www.youtube.com/channel/yourchannel','Myriad Pro Regular',30,0xFFFFFF),
		new GshahTextFont('More videos from our channel','Myriad Pro Regular',30,0xFFFFFF),
		new GshahTextFont('Subscribe','Myriad Pro Regular',30,0xFFFFFF)];

		
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
			return 9;
		}
		public function get numLogos():int
		{
			return 4;
		}
		public function get videoDatas():Array
		{
			return [new OutroVideoData(125.55+10, 688.3+10,444.8,250.2, 83),
			new OutroVideoData(735.95+10, 688.3+10,444.8,250.2, 83),
			new OutroVideoData(1356.3+10, 688.3+10,444.8,250.2, 83),
			new OutroVideoData(133.85+10, 78.35+10,795.35-20, 454.85-20, 108)];
		}
	}
}