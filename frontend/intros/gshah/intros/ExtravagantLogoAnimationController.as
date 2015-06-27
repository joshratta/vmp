package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.ExtravagantLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ExtravagantLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ExtravagantLogoAnimationController()
		{
			_content=new ExtravagantLogo(this);
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
			return -368;
		}
		public function get contentPaddingTop():Number
		{
			return -457;
		}
		public function get contentWidth():Number
		{
			return 1625;
		}
		public function get contentHeight():Number
		{
			return 1437;
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