package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SwooshLines1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SwooshLines1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SwooshLines1AnimationController()
		{
			_content=new SwooshLines1(this);
		}
		private var texts:Array=[new GshahTextFont('Yourcompany','Myriad Pro Bold Condensed',29,0x000000), new GshahTextFont('LOWER THIRDS WITH LINED FRAMES','Myriad Pro Regular',28,0xFFFFFF), new GshahTextFont('Little text can be here','Myriad Pro Regular',20,0x88FF38)];
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
			return -330;
		}
		public function get contentPaddingTop():Number
		{
			return 76;
		}
		public function get contentWidth():Number
		{
			return 745;
		}
		public function get contentHeight():Number
		{
			return 143;
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