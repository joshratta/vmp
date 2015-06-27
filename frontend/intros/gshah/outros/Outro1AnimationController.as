package gshah.outros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueBublesLogo;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	import gshah.intros.texts.GshahTextFont;
	
	public class Outro1AnimationController implements IGshahOutroController
	{
		private var _content:MovieClip;
		public function Outro1AnimationController()
		{
			_content=new Outro1(this);
		}
		private var texts:Array=[new GshahTextFont('Textfield one\nYour first video','Myriad Pro Regular',40,0x000000),new GshahTextFont('Textfield two\nYour best video','Myriad Pro Regular',40,0x000000),
		new GshahTextFont('Something about\nLast video','Myriad Pro Regular',40,0x000000),new GshahTextFont('Write some text\nfor this one :)','Myriad Pro Regular',40,0x000000),
		new GshahTextFont('Join us for more videos like','Myriad Pro Condensed',46,0x000000),new GshahTextFont('this every week! It\'s fFREE!','Myriad Pro Condensed',46,0x000000),
		new GshahTextFont('MORE FROM OUR CHANNEL','Myriad Pro Bold Condensed',79,0x000000),new GshahTextFont('Subscribe','Myriad Pro Regular',96,0xFFFFFF)];
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
			return 8;
		}
		public function get numLogos():int
		{
			return 5;
		}
		public function get videoDatas():Array
		{
			return [new OutroVideoData(58.35,684.45,416,234,40),
			new OutroVideoData(523.15,684.45,416,234,43),
			new OutroVideoData(987.95,684.45,416,234,46),
			new OutroVideoData(1452.75,684.45,416,234,49),
			new OutroVideoData(58.35,88.6,851.75,479.1,13),];
		}
	}
}