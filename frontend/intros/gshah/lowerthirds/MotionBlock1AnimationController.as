package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MotionBlock1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MotionBlock1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MotionBlock1AnimationController()
		{
			_content=new MotionBlock1(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRDS BLOCKS AND LINES','Nexa Bold Regular',25,0xD6DADB)];
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
			return -316;
		}
		public function get contentPaddingTop():Number
		{
			return -61;
		}
		public function get contentWidth():Number
		{
			return 600;
		}
		public function get contentHeight():Number
		{
			return 126;
		}
		
		public function get numTexts():int
		{
			return 1;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}