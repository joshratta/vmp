package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.RetroLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class RetroLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function RetroLowerThird2AnimationController()
		{
			_content=new RetroLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRD ONE','Myriad Pro Condensed',50,0xFFFFFF)];
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
			return 249;
		}
		public function get contentPaddingTop():Number
		{
			return 431;
		}
		public function get contentWidth():Number
		{
			return 482;
		}
		public function get contentHeight():Number
		{
			return 112;
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