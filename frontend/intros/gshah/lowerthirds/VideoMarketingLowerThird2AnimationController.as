package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.VideoMarketingLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class VideoMarketingLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function VideoMarketingLowerThird2AnimationController()
		{
			_content=new VideoMarketingLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRDS 2','Myriad Pro Condensed Italic',50,0xFFFFFF), new GshahTextFont('Architect  JOHN DOE ','Myriad Pro Condensed Italic',28,0xFFFFFF)];
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
			return -265;
		}
		public function get contentPaddingTop():Number
		{
			return -127;
		}
		public function get contentWidth():Number
		{
			return 536;
		}
		public function get contentHeight():Number
		{
			return 229;
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