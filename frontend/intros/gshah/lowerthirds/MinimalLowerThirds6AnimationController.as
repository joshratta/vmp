package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MinimalLowerThirds6;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MinimalLowerThirds6AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MinimalLowerThirds6AnimationController()
		{
			_content=new MinimalLowerThirds6(this);
		}
		private var texts:Array=[new GshahTextFont('LOWER THIRDS NUMBER ONE','Myriad Pro Regular',34,0xFFFFFF), new GshahTextFont('YourLogo','Myriad Pro Italic',23,0xFFFFFF)];
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
			return 417;
		}
		public function get contentWidth():Number
		{
			return 454;
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
			return 1;
		}
	}
}