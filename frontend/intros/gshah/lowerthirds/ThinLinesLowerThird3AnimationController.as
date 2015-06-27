package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ThinLinesLowerThird3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ThinLinesLowerThird3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ThinLinesLowerThird3AnimationController()
		{
			_content=new ThinLinesLowerThird3(this);
		}
		private var texts:Array=[new GshahTextFont('LOREM IPSUM DOLOR SIT AMET','Myriad Pro Regular',28, 0xFFFFFF), new GshahTextFont('Consectetuer adipiscing elit','Myriad Pro Regular',20, 0xFF0070), new GshahTextFont('VERY IMPORTANT INFO HERE','Myriad Pro Regular',18, 0xFFFFFF), new GshahTextFont('LITTERARUM FORMAS HUMANITATIS','Myriad Pro Regular',16, 0xFFFFFF)];
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
			return -467;
		}
		public function get contentPaddingTop():Number
		{
			return 69;
		}
		public function get contentWidth():Number
		{
			return 883;
		}
		public function get contentHeight():Number
		{
			return 138;
		}
		public function get numTexts():int
		{
			return 4;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}