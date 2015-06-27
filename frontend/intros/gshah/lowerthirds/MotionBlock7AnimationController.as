package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MotionBlock7;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MotionBlock7AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MotionBlock7AnimationController()
		{
			_content=new MotionBlock7(this);
		}
		private var texts:Array=[new GshahTextFont('ONE LINE LOWER THIRD','Nexa Bold Regular',36,0xD6DADB)];
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
			return -383;
		}
		public function get contentPaddingTop():Number
		{
			return 91;
		}
		public function get contentWidth():Number
		{
			return 568;
		}
		public function get contentHeight():Number
		{
			return 62;
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