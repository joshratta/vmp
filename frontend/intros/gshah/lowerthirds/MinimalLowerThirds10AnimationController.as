package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MinimalLowerThirds10;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MinimalLowerThirds10AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MinimalLowerThirds10AnimationController()
		{
			_content=new MinimalLowerThirds10(this);
		}
		private var texts:Array=[new GshahTextFont('YourLogo','Myriad Pro Italic',23,0xFFFFFF)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[null, null];
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
			return 755;
		}
		public function get contentPaddingTop():Number
		{
			return 411;
		}
		public function get contentWidth():Number
		{
			return 203;
		}
		public function get contentHeight():Number
		{
			return 85;
		}
		public function get numTexts():int
		{
			return 1;
		}
		public function get numLogos():int
		{
			return 2;
		}
	}
}