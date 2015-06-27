package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.FreshTextSlide3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class FreshTextSlide3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function FreshTextSlide3AnimationController()
		{
			_content=new FreshTextSlide3(this);
		}
		private var texts:Array=[new GshahTextFont('LOREM','Myriad Pro Regular',78,0x009FD8), new GshahTextFont('IPSUM','Myriad Pro Bold',78,0x009FD8), new GshahTextFont('OLD','Myriad Pro Bold',96,0xFFFFFF), new GshahTextFont('AND NEW','Myriad Pro Bold',50,0xFFFFFF)];
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