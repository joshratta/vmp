package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernLowerThird2AnimationController()
		{
			_content=new ModernLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR TEXT OR NAME','Myriad Pro Regular',36,0xFFFFFF),new GshahTextFont('YOUR DESCRIPTION 2','Myriad Pro Regular',26,0xFFFFFF)];
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
			return 0;
		}
		public function get contentPaddingTop():Number
		{
			return 43;
		}
		public function get contentWidth():Number
		{
			return 734;
		}
		public function get contentHeight():Number
		{
			return 117;
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