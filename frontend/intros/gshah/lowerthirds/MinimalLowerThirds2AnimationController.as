package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MinimalLowerThirds2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MinimalLowerThirds2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MinimalLowerThirds2AnimationController()
		{
			_content=new MinimalLowerThirds2(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRDS NUMBER TWO','Myriad Pro Regular',34,0xFFFFFF), new GshahTextFont('SUBTITLE NUMBER ONE','Myriad Pro Regular',30,0x000000)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[];
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
			return 445;
		}
		public function get contentPaddingTop():Number
		{
			return 398;
		}
		public function get contentWidth():Number
		{
			return 511;
		}
		public function get contentHeight():Number
		{
			return 100;
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