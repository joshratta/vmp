package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.VideoInsert4;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	public class VideoInsert4AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function VideoInsert4AnimationController()
		{
			_content=new VideoInsert4(this);
		}
		private var texts:Array=[new GshahTextFont('HEADLINE','Myriad Pro Regular',30,0xFFFFFF),new GshahTextFont('Enter Your text here.  How much longer text you need. Bla bla bla.\nand more..','Myriad Pro Regular',22,0x000033)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[null];
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
			return 392;
		}
		
		public function get contentWidth():Number
		{
			return 960;
		}
		public function get contentHeight():Number
		{
			return 150;
		}
		public function get numTexts():int
		{
			return 2;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}