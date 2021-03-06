package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.CleanLowerThird3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class CleanLowerThird3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function CleanLowerThird3AnimationController()
		{
			_content=new CleanLowerThird3(this);
		}
		private var texts:Array=[new GshahTextFont('dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. ','Myriad Pro Regular',16,0x000000)];
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
			return 204;
		}
		public function get contentPaddingTop():Number
		{
			return 380;
		}
		public function get contentWidth():Number
		{
			return 554;
		}
		public function get contentHeight():Number
		{
			return 160;
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