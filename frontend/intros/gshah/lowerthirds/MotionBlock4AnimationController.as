package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MotionBlock4;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MotionBlock4AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MotionBlock4AnimationController()
		{
			_content=new MotionBlock4(this);
		}
		private var texts:Array=[new GshahTextFont('EASY TO CUSTOMIZE','Nexa Bold Regular',25,0xD6DADB), new GshahTextFont('YOUR HEADER','Nexa Bold Regular',20,0x000000)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[];
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
			return -446;
		}
		public function get contentPaddingTop():Number
		{
			return 67;
		}
		public function get contentWidth():Number
		{
			return 510;
		}
		public function get contentHeight():Number
		{
			return 86;
		}
		
		public function get numTexts():int
		{
			return 2;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}