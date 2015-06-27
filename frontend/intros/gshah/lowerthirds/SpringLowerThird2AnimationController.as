package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SpringLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SpringLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SpringLowerThird2AnimationController()
		{
			_content=new SpringLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('TWO LINE LOWER THIRD','Myriad Pro Bold',37,0x333333),new GshahTextFont('aditional information here','Myriad Pro Regular',24,0x333333)];
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
			return 203;
		}
		public function get contentPaddingTop():Number
		{
			return 335;
		}
		public function get contentWidth():Number
		{
			return 594;
		}
		public function get contentHeight():Number
		{
			return 107;
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