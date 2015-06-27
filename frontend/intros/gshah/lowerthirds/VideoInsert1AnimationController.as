package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.VideoInsert1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class VideoInsert1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function VideoInsert1AnimationController()
		{
			_content=new VideoInsert1(this);
		}
		private var texts:Array=[];
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
			return -112;
		}
		public function get contentPaddingTop():Number
		{
			return -376;
		}
		public function get contentWidth():Number
		{
			return 1376;
		}
		public function get contentHeight():Number
		{
			return 1172;
		}
		public function get numTexts():int
		{
			return 0;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}