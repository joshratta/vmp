package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.SmoothSlide1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SmoothSlide1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SmoothSlide1AnimationController()
		{
			_content=new SmoothSlide1(this);
		}
		private var texts:Array=[new GshahTextFont('45','Myriad Pro Bold Condensed Italic',150,0xE161AA), new GshahTextFont('LOREM','Myriad Pro Bold Condensed Italic',96,0xFFFFFF), new GshahTextFont('IPSUM','Myriad Pro Bold Condensed Italic',45,0xE161AA), new GshahTextFont('TITLES','Myriad Pro Bold Condensed Italic',120,0xFFFFFF), new GshahTextFont('ANIMATIONS','Myriad Pro Condensed',45,0xE161AA)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[];
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
			return 960;
		}
		public function get contentHeight():Number
		{
			return 540;
		}
		public function get numTexts():int
		{
			return 5;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}