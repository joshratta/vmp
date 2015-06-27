package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.SmoothSlide21;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SmoothSlide21AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SmoothSlide21AnimationController()
		{
			_content=new SmoothSlide21(this);
		}
		private var texts:Array=[new GshahTextFont('LOREM','Tahoma Bold',58,0xFFFFFF), new GshahTextFont('IPSUM','Tahoma Bold',77,0xFFFFFF), new GshahTextFont('DOLOR','Tahoma Regular',50,0xFFC400), new GshahTextFont('SIT AMET','Tahoma Regular',40,0xFFC400)];
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
			return 0;
		}
		
		public function get contentPaddingTop():Number
		{
			return 0;
		}
		
		public function get contentWidth():Number
		{
			return 960;
		}
		public function get contentHeight():Number
		{
			return 540;
		}
		public function get numTexts():int
		{
			return 4;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}