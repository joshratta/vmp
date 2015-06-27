package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird4;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class GlitchCinematicTitlesLowerThird4AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function GlitchCinematicTitlesLowerThird4AnimationController()
		{
			_content=new GlitchCinematicTitlesLowerThird4(this);
		}
		private var texts:Array=[new GshahTextFont('BILLY BOB THORNTON','Nexa Light Regular',18,0xFFFFFF),new GshahTextFont('CREATIVE DIRECTOR','Nexa Light Regular',18,0xFFFFFF)];
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
			return -101;
		}
		public function get contentPaddingTop():Number
		{
			return 58;
		}
		public function get contentWidth():Number
		{
			return 1319;
		}
		public function get contentHeight():Number
		{
			return 456;
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