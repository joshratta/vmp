package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ThinLinesLowerThird2;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ThinLinesLowerThird2AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ThinLinesLowerThird2AnimationController()
		{
			_content=new ThinLinesLowerThird2(this);
		}
		private var texts:Array=[new GshahTextFont('SECOND LOWER THIRDS WITH LINED FRAMES','Myriad Pro Regular',28, 0xFFFFFF), new GshahTextFont('Another little text can be here','Myriad Pro Regular',20, 0xFF0070), new GshahTextFont('THIRD LITTLE TEXT HERE','Myriad Pro Regular',18, 0xFFFFFF)];
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
			return -469;
		}
		public function get contentPaddingTop():Number
		{
			return 76;
		}
		public function get contentWidth():Number
		{
			return 884;
		}
		public function get contentHeight():Number
		{
			return 132;
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