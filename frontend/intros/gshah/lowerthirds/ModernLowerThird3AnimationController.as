package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernLowerThird3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernLowerThird3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernLowerThird3AnimationController()
		{
			_content=new ModernLowerThird3(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR TEXT OR NAME 3','Myriad Pro Regular',36,0xFFFFFF), new GshahTextFont('YOUR DESCRIPTION 3','Myriad Pro Regular',25,0xFFFFFF)];
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
			return 57;
		}
		public function get contentPaddingTop():Number
		{
			return 412;
		}
		public function get contentWidth():Number
		{
			return 787;
		}
		public function get contentHeight():Number
		{
			return 81;
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