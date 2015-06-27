package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.FreshLogoSting;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class FreshLogoStingAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function FreshLogoStingAnimationController()
		{
			_content=new FreshLogoSting(this);
		}
		private var texts:Array=[new GshahTextFont('www.yourcompany.com','Arial Regular',24,0x333333)];
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
			return 247;
		}
		public function get contentPaddingTop():Number
		{
			return 32;
		}
		public function get contentWidth():Number
		{
			return 467;
		}
		public function get contentHeight():Number
		{
			return 462;
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