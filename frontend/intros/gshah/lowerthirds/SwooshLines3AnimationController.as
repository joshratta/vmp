package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SwooshLines3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SwooshLines3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SwooshLines3AnimationController()
		{
			_content=new SwooshLines3(this);
		}
		private var texts:Array=[new GshahTextFont('Yourcompany','Myriad Pro Bold Condensed',29,0x000000), new GshahTextFont('LOREM IPSUM','Myriad Pro Regular',28,0xFFFFFF), new GshahTextFont('Consectetuer adipiscing elit','Myriad Pro Regular',20,0x88FF38), new GshahTextFont('VERY IMPORTANT INFO HERE','Myriad Pro Regular',18,0x000000), new GshahTextFont('LITTERARUM FORMAS HUMANITATIS','Myriad Pro Regular',16,0x000000)];
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
			return -356;
		}
		public function get contentPaddingTop():Number
		{
			return 71;
		}
		public function get contentWidth():Number
		{
			return 879;
		}
		public function get contentHeight():Number
		{
			return 148;
		}
		public function get numTexts():int
		{
			return 5;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}