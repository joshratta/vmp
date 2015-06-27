package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SimpleLowerThirds2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SimpleLowerThirds2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SimpleLowerThirds2AnimationController()
		{
			_content=new SimpleLowerThirds2(this);
		}
		private var texts:Array=[new GshahTextFont('TEXT LINE 2','Myriad Pro Regular',50,0xFFFFFF), new GshahTextFont('DIRECTOR','Myriad Pro Regular',20,0x000000)];
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
			return -721;
		}
		public function get contentPaddingTop():Number
		{
			return 111;
		}
		public function get contentWidth():Number
		{
			return 722;
		}
		public function get contentHeight():Number
		{
			return 89;
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