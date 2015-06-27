package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernNavyLowerThird4;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernNavyLowerThird4AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernNavyLowerThird4AnimationController()
		{
			_content=new ModernNavyLowerThird4(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR TEXT GOES HERE','Ubuntu Medium',75,0x3CC7D5),new GshahTextFont('TITLE GOES HERE','Ubuntu Medium',32,0x3CC7D5),new GshahTextFont('TITLE FOR TEXT','Myriad Pro Bold',26,0xFFFFFF),new GshahTextFont(' Dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem.\ndolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. ','Myriad Pro Regular',16,0xFFFFFF)];
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
			return -11;
		}
		public function get contentPaddingTop():Number
		{
			return 0;
		}
		public function get contentWidth():Number
		{
			return 1035;
		}
		public function get contentHeight():Number
		{
			return 548;
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