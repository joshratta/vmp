package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro2AnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro2AnimationController()
		{
			_content=new Outro2(this);
		}
		private var texts:Array=[new GshahTextFont('Text for first video\nText line 2','Myriad Pro Regular',32,0x000000),new GshahTextFont('Text for second video\nText line 2','Myriad Pro Regular',32,0x000000),
		new GshahTextFont('Text for third video\nText line 2','Myriad Pro Regular',32,0x000000),new GshahTextFont('Text for forth video\nText line 2','Myriad Pro Regular',32,0x000000),
		new GshahTextFont('Description of your channel\nyou can write here\nWith love :)','Myriad Pro Condensed Italic',63,0xFFFFFF),new GshahTextFont('Subscribe now','Myriad Pro Condensed',58,0xFFFFFF)];
		
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
			return 6;
		}
		public function get numLogos():int
		{
			return 5;
		}
		public function get videoDatas():Array
		{
			return [new OutroVideoData(96.6,715.1,375.45,211.2,53),
			new OutroVideoData(554.35,715.1,375.45,211.2,60),
			new OutroVideoData(1012.1,715.1,375.45,211.2,57),
			new OutroVideoData(1469.85,715.1,375.45,211.2,73),
			new OutroVideoData(96.6,96.6,862,484.9,31)];
		}
	}
}