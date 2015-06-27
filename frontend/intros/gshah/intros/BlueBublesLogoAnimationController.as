package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class BlueBublesLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function BlueBublesLogoAnimationController()
		{
			_content=new BlueBublesLogo(this);
		}
		private var texts:Array=[new GshahTextFont('yourdomain.com','Myriad Pro Regular',22,0xFFFFFF)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;		
			
		}
		private var logos:Array=[null,null];
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
			return 513;
		}
		public function get contentPaddingTop():Number
		{
			return 118;
		}
		public function get contentWidth():Number
		{
			return 852;
		}
		public function get contentHeight():Number
		{
			return 826;
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