package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernLowerThird1;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernLowerThird1AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernLowerThird1AnimationController()
		{
			_content=new ModernLowerThird1(this);
		}
		private var texts:Array=[new GshahTextFont('YOUR MAIN TITLE','Myriad Pro Regular',34,0xFFFFFF), new GshahTextFont('YOUR DESCRIPTION','Myriad Pro Regular',16,0xFFFFFF), new GshahTextFont('1 Lower thirds','Myriad Pro Regular',16,0xFFFFFF), new GshahTextFont('2 infoboxes','Myriad Pro Regular',16,0xFFFFFF), new GshahTextFont('3 logoholder','Myriad Pro Regular',16,0xFFFFFF), new GshahTextFont('4 Easy to edit','Myriad Pro Regular',16,0xFFFFFF)];
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
			return 181;
		}
		public function get contentPaddingTop():Number
		{
			return 342;
		}
		public function get contentWidth():Number
		{
			return 594;
		}
		public function get contentHeight():Number
		{
			return 169;
		}
		public function get numTexts():int
		{
			return 6;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}