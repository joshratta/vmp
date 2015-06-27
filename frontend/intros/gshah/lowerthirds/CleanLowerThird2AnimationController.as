package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.CleanLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class CleanLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function CleanLowerThird2AnimationController()
		{
			_content=new CleanLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('BIG TEXT 2','Myriad Pro Bold',36,0x000000),new GshahTextFont('SMALL TEXT 2','Myriad Pro Regular',28,0x000000)];
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
			return 97;
		}
		public function get contentPaddingTop():Number
		{
			return 365;
		}
		public function get contentWidth():Number
		{
			return 355;
		}
		public function get contentHeight():Number
		{
			return 113;
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