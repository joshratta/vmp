package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.RetroLowerThird1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class RetroLowerThird1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function RetroLowerThird1AnimationController()
		{
			_content=new RetroLowerThird1(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRD FIRST LINE','Myriad Pro Bold Condensed',50,0xFFFFFF), new GshahTextFont('SMALL TEXT FOR BLA BLA','Myriad Pro Condensed',30,0xFFFFFF)];
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
			return 170;
		}
		public function get contentWidth():Number
		{
			return 482;
		}
		public function get contentHeight():Number
		{
			return 172;
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