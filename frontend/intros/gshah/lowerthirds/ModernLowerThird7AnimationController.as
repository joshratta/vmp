package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernLowerThird7;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernLowerThird7AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernLowerThird7AnimationController()
		{
			_content=new ModernLowerThird7(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR DESCRIPTION 7','Myriad Pro Regular',18,0xFFFFFF), new GshahTextFont('dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. ','Myriad Pro Regular',16,0xFFFFFF)];
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
			return 0.;
		}
		public function get contentPaddingTop():Number
		{
			return 112;
		}
		public function get contentWidth():Number
		{
			return 230;
		}
		public function get contentHeight():Number
		{
			return 250;
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