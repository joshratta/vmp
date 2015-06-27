package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.ClickLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ClickLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ClickLogoAnimationController()
		{
			_content=new ClickLogo(this);
		}
		private var texts:Array=[new GshahTextFont('your slogan here','Myriad Pro Condensed',27,0xFFFFFF),new GshahTextFont('www.yourdomain.com','Myriad Pro Condensed',27,0xFFFFFF),new GshahTextFont('facebook.com/yourcompany','Myriad Pro Condensed',22,0xFFFFFF),new GshahTextFont('follow us','Myriad Pro Condensed',37,0xFFFFFF),new GshahTextFont('twitter.com/yourcompany','Myriad Pro Condensed',22,0xFFFFFF)];
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
			return 327;
		}
		public function get contentPaddingTop():Number
		{
			return 0;
		}
		public function get contentWidth():Number
		{
			return 359;
		}
		public function get contentHeight():Number
		{
			return 394;
		}
		public function get numTexts():int
		{
			return 5;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}