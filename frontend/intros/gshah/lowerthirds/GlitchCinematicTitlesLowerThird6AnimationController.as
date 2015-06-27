package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird6;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class GlitchCinematicTitlesLowerThird6AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function GlitchCinematicTitlesLowerThird6AnimationController()
		{
			_content=new GlitchCinematicTitlesLowerThird6(this);
		}
		private var texts:Array=[new GshahTextFont('THREE LINE LOWER THIRD','Nexa Light Regular',96,0xFFFFFF),new GshahTextFont('BOTTOM TEXT HERE','Nexa Light Regular',18,0xFFFFFF),new GshahTextFont('TOP TEXT HERE','Nexa Light Regular',16,0xFFFFFF)];
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
			return -88;
		}
		public function get contentPaddingTop():Number
		{
			return 129;
		}
		public function get contentWidth():Number
		{
			return 1192;
		}
		public function get contentHeight():Number
		{
			return 388;
		}
		public function get numTexts():int
		{
			return 3;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}