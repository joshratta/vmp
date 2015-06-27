package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.OrigamiStarLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class OrigamiStarLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function OrigamiStarLogoAnimationController()
		{
			_content=new OrigamiStarLogo(this);
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
			return 336;
		}
		public function get contentPaddingTop():Number
		{
			return 113;
		}
		public function get contentWidth():Number
		{
			return 286;
		}
		public function get contentHeight():Number
		{
			return 309;
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