package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.RetroLowerThird7;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class RetroLowerThird7AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function RetroLowerThird7AnimationController()
		{
			_content=new RetroLowerThird7(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRDS & LOGO','Myriad Pro Condensed',50,0xFFFFFF)];
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
			return 0;
		}
		public function get contentPaddingTop():Number
		{
			return 396;
		}
		public function get contentWidth():Number
		{
			return 603;
		}
		public function get contentHeight():Number
		{
			return 137;
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