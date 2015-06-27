package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.UnfoldLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class UnfoldLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function UnfoldLogoAnimationController()
		{
			_content=new UnfoldLogo(this);
		}
		private var texts:Array=[new GshahTextFont('yourcompany.com','Futura Bk BT',30,0x0033CC)];
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
			return 174;
		}
		public function get contentPaddingTop():Number
		{
			return 39;
		}
		public function get contentWidth():Number
		{
			return 553;
		}
		public function get contentHeight():Number
		{
			return 507;
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