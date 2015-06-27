package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SimpleLowerThirds7;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SimpleLowerThirds7AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SimpleLowerThirds7AnimationController()
		{
			_content=new SimpleLowerThirds7(this);
		}
		private var texts:Array=[new GshahTextFont('DOLOR SIT AMET','Myriad Pro Regular',38,0xFFFFFF), new GshahTextFont('LOWER THIRD WITH LOGO','Myriad Pro Regular',16,0x000000), new GshahTextFont('THANK YOU','Myriad Pro Regular',16,0xFFFFFF)];
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
			return -598;
		}
		public function get contentPaddingTop():Number
		{
			return 102;
		}
		public function get contentWidth():Number
		{
			return 598;
		}
		public function get contentHeight():Number
		{
			return 90;
		}
		
		public function get numTexts():int
		{
			return 3;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}