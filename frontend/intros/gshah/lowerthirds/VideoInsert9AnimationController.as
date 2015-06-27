package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.VideoInsert9;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class VideoInsert9AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function VideoInsert9AnimationController()
		{
			_content=new VideoInsert9(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR MESSAGE HERE','Myriad Pro Regular',50,0xFFFFFF), new GshahTextFont('enter your subtitle','Myriad Pro Regular',22,0x000000)];
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
			return 163;
		}
		public function get contentPaddingTop():Number
		{
			return 169;
		}
		public function get contentWidth():Number
		{
			return 629;
		}
		public function get contentHeight():Number
		{
			return 104;
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