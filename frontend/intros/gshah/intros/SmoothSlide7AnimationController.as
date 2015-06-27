package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.SmoothSlide7;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SmoothSlide7AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SmoothSlide7AnimationController()
		{
			_content=new SmoothSlide7(this);
		}
		private var texts:Array=[new GshahTextFont('TEXT','Myriad Pro Bold Condensed',65,0xB60000), new GshahTextFont('ANIMATION','Myriad Pro Bold Condensed',74,0x000000), new GshahTextFont('LOREM','Myriad Pro Bold Condensed',80,0x000000), new GshahTextFont('IPSUM','Myriad Pro Condensed',50,0x000000)];
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
			return 4;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}