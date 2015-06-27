package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BouncingStarsLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class BouncingStarsLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function BouncingStarsLogoAnimationController()
		{
			_content=new BouncingStarsLogo(this);
		}
		private var texts:Array=[new GshahTextFont('COMPANY NAME','Gotham Book Regular',34,0xFFB600)];
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
			return 263;
		}
		public function get contentPaddingTop():Number
		{
			return -31;
		}
		public function get contentWidth():Number
		{
			return 443;
		}
		public function get contentHeight():Number
		{
			return 425;
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