package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro10AnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro10AnimationController()
		{
			_content=new Outro10(this);
		}
		private var texts:Array=[new GshahTextFont('yoursite.com','Myriad Pro Regular',32,0xFFFFFF),new GshahTextFont('www.facebook.com/yourpagelink','Myriad Pro Condensed',54,0xFFFFFF),new GshahTextFont('www.twitter.com/yoursitename','Myriad Pro Condensed',54,0xFFFFFF)];
		
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;		
			
		}
		private var logos:Array=[null,null,null,null,null];
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
			return 0;
		}
		public function get contentWidth():Number
		{
			return 1920;
		}
		public function get contentHeight():Number
		{
			return 1080;
		}
		public function get numTexts():int
		{
			return 3;
		}
		public function get numLogos():int
		{
			return 0;
		}
		public function get videoDatas():Array
		{
			return [];
		}
	}
}