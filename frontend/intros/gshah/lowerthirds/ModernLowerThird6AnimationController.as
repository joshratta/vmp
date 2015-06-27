package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.ModernLowerThird6;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class ModernLowerThird6AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function ModernLowerThird6AnimationController()
		{
			_content=new ModernLowerThird6(this);
		}
		private var texts:Array=['YOUR TEXT 1'];
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
			return 815;
		}
		public function get contentPaddingTop():Number
		{
			return 52;
		}
		public function get contentWidth():Number
		{
			return 145;
		}
		public function get contentHeight():Number
		{
			return 94;
		}
		public function get numTexts():int
		{
			return 0;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}