package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MotionBlock9;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MotionBlock9AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MotionBlock9AnimationController()
		{
			_content=new MotionBlock9(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR SLOGAN HERE','Nexa Bold Regular',36,0xD6DADB), new GshahTextFont('www.yourcompany.com','Nexa Bold Regular',20,0x000000)];
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
			return -383;
		}
		public function get contentPaddingTop():Number
		{
			return 65;
		}
		public function get contentWidth():Number
		{
			return 568;
		}
		public function get contentHeight():Number
		{
			return 89;
		}
		
		public function get numTexts():int
		{
			return 2;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}