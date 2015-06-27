package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.TextSlideModernConcept3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class TextSlideModernConcept3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function TextSlideModernConcept3AnimationController()
		{
			_content=new TextSlideModernConcept3(this);
		}
		private var texts:Array=[new GshahTextFont('FIRST TEXT','Nexa Bold Regular',49,0xFFFFFF), new GshahTextFont('SECOND ONE','Nexa Bold Regular',49,0x3F3F3F), new GshahTextFont('AND AGAIN','Nexa Bold Regular',49,0xFFFFFF)];
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
			return 0;
		}
		
		public function get contentPaddingTop():Number
		{
			return 0;
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
			return 3;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}