package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernNavyLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernNavyLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernNavyLowerThird2AnimationController()
		{
			_content=new ModernNavyLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('ADD YOUR TEXT HERE','Ubuntu Medium',75,0x3CC7D5),new GshahTextFont('YOUR TEXT','Ubuntu Medium',40,0x3CC7D5),new GshahTextFont('SECOND LINE HERE','Ubuntu Medium',19,0x3CC7D5)];
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
			return 68;
		}
		public function get contentWidth():Number
		{
			return 985;
		}
		public function get contentHeight():Number
		{
			return 600;
		}
		public function get numTexts():int
		{
			return 3;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}