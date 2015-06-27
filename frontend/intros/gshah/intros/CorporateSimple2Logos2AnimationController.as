package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.CorporateSimple2Logos;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class CorporateSimple2Logos2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function CorporateSimple2Logos2AnimationController()
		{
			_content=new CorporateSimple2Logos2(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR SLOGAN GOES HERE','Myriad Pro Bold Condensed Italic',16,0x000000)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[null,null];
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
			return 80;
		}
		public function get contentPaddingTop():Number
		{
			return 139;
		}
		public function get contentWidth():Number
		{
			return 970;
		}
		public function get contentHeight():Number
		{
			return 262;
		}
		public function get numTexts():int
		{
			return 1;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}