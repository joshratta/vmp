package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.FunLowerThirds2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class FunLowerThirds2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function FunLowerThirds2AnimationController()
		{
			_content=new FunLowerThirds2(this);
		}
		private var texts:Array=[new GshahTextFont('SINGLE LINE INFORMATION GOES HERE','Myriad Pro Bold',28,0xFFFFFF), 
		new GshahTextFont('Aditional text goes here','Myriad Pro Regular',20,0x000000),
		new GshahTextFont('www.yourcompany.com','Myriad Pro Regular',20,0x000000)];
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
			return -547;
		}
		public function get contentPaddingTop():Number
		{
			return 113;
		}
		public function get contentWidth():Number
		{
			return 1027;
		}
		public function get contentHeight():Number
		{
			return 124;
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