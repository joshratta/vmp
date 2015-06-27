package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernLowerThird4;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernLowerThird4AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernLowerThird4AnimationController()
		{
			_content=new ModernLowerThird4(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR TEXT OR NAME 4','Myriad Pro Regular',36,0xFFFFFF), new GshahTextFont('YOUR DESCRIPTION 4','Myriad Pro Regular',30,0xFFFFFF)];
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
			return 84;
		}
		public function get contentPaddingTop():Number
		{
			return 400;
		}
		public function get contentWidth():Number
		{
			return 697;
		}
		public function get contentHeight():Number
		{
			return 87;
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