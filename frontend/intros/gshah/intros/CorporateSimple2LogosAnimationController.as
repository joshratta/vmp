package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.CorporateSimple2Logos;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class CorporateSimple2LogosAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function CorporateSimple2LogosAnimationController()
		{
			_content=new CorporateSimple2Logos(this);
		}
		private var texts:Array=[new GshahTextFont('Your Slogan or Something Else','Myriad Pro Bold Italic',32,0x333333),new GshahTextFont('www.yourdomain.com','Myriad Pro Italic',22,0x333333)];
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
			return 2;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}