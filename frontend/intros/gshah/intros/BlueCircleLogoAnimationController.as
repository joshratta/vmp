package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.BlueCircleLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class BlueCircleLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function BlueCircleLogoAnimationController()
		{
			_content=new BlueCircleLogo(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR TEXT GOES HERE','Myriad Pro Regular',36, 0xFFFFFF),new GshahTextFont('YOUR TEXT GOES HERE','Myriad Pro Regular',36,0x38E4EF)];
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
			return 692;
		}
		public function get contentPaddingTop():Number
		{
			return 317;
		}
		public function get contentWidth():Number
		{
			return 493;
		}
		public function get contentHeight():Number
		{
			return 450;
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