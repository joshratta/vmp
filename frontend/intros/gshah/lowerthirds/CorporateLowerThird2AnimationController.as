package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.CorporateLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class CorporateLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function CorporateLowerThird2AnimationController()
		{
			_content=new CorporateLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR PROJECT NAME 2','Myriad Pro Bold',75,0x000000),new GshahTextFont('NEXT TEXT 2','Myriad Pro Bold',40,0xFEC913),new GshahTextFont('SECOND LINE HERE','Myriad Pro Regular',19,0x000000)];
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
			return -13;
		}
		public function get contentPaddingTop():Number
		{
			return 68;
		}
		public function get contentWidth():Number
		{
			return 995;
		}
		public function get contentHeight():Number
		{
			return 450;
		}
		public function get numTexts():int
		{
			return 3;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}