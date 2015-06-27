package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SimpleLowerThirds1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SimpleLowerThirds1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SimpleLowerThirds1AnimationController()
		{
			_content=new SimpleLowerThirds1(this);
		}
		private var texts:Array=[new GshahTextFont('LOREM IPSUM','Myriad Pro Regular',50,0xFFFFFF), new GshahTextFont('DOLOR SIT AMET','Myriad Pro Regular',20,0x000000)];
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
			return -725;
		}
		public function get contentPaddingTop():Number
		{
			return 105;
		}
		public function get contentWidth():Number
		{
			return 726;
		}
		public function get contentHeight():Number
		{
			return 90;
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