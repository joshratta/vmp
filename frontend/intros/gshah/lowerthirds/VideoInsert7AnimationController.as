package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.VideoInsert7;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class VideoInsert7AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function VideoInsert7AnimationController()
		{
			_content=new VideoInsert7(this);
		}
		private var texts:Array=[new GshahTextFont('ENTER YOUR MAIN TITLE','Myriad Pro Regular',48,0xFFFFFF),new GshahTextFont('enter your subtitle','Myriad Pro Regular',22,0x000000)];
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
			return 156;
		}
		public function get contentPaddingTop():Number
		{
			return 134;
		}
		public function get contentWidth():Number
		{
			return 617;
		}
		public function get contentHeight():Number
		{
			return 111;
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