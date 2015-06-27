package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird10;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class GlitchCinematicTitlesLowerThird10AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function GlitchCinematicTitlesLowerThird10AnimationController()
		{
			_content=new GlitchCinematicTitlesLowerThird10(this);
		}
		private var texts:Array=[new GshahTextFont('JOHN MALKOVICH','Nexa Light Regular',96,0xFFFFFF),new GshahTextFont('LOWER THIRDS','Nexa Light Regular',26,0xA4BFCC)];
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
			return -49;
		}
		public function get contentPaddingTop():Number
		{
			return 46;
		}
		public function get contentWidth():Number
		{
			return 1076;
		}
		public function get contentHeight():Number
		{
			return 457;
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