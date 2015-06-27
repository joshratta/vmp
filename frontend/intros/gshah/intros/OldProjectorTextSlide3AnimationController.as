package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.OldProjectorTextSlide3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class OldProjectorTextSlide3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function OldProjectorTextSlide3AnimationController()
		{
			_content=new OldProjectorTextSlide3(this);
		}
		private var texts:Array=[new GshahTextFont('Editable','Embassy BT Regular',75,0xCCCCCC), new GshahTextFont('TEXT','Oswald Light Light',96,0xCCCCCC)];
		public function setText(value:GshahTextFont, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[];
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
			return -480;
		}
		
		public function get contentPaddingTop():Number
		{
			return -270;
		}
		
		public function get contentWidth():Number
		{
			return 960;
		}
		public function get contentHeight():Number
		{
			return 540;
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