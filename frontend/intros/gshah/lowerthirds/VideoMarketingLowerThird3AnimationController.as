package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.VideoMarketingLowerThird3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class VideoMarketingLowerThird3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function VideoMarketingLowerThird3AnimationController()
		{
			_content=new VideoMarketingLowerThird3(this);
		}
		private var texts:Array=[new GshahTextFont('SHOWTIME','Myriad Pro Bold Condensed Italic',50,0xFFFFFF), new GshahTextFont('11:00','Myriad Pro Bold Condensed Italic',40,0xFFFFFF), new GshahTextFont('Programm 1','Myriad Pro Condensed Italic',30,0xFFFFFF), new GshahTextFont('16:20','Myriad Pro Bold Condensed Italic',40,0xFFFFFF), new GshahTextFont('Programm 2','Myriad Pro Condensed Italic',30,0xFFFFFF), new GshahTextFont('23:10','Myriad Pro Bold Condensed Italic',40,0xFFFFFF), new GshahTextFont('Programm 3','Myriad Pro Condensed Italic',30,0xFFFFFF)];
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
			return -244;
		}
		public function get contentPaddingTop():Number
		{
			return -484;
		}
		public function get contentWidth():Number
		{
			return 469;
		}
		public function get contentHeight():Number
		{
			return 950;
		}
		public function get numTexts():int
		{
			return 7;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}