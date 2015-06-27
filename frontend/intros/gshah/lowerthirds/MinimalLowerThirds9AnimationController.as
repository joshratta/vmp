package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MinimalLowerThirds9;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MinimalLowerThirds9AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MinimalLowerThirds9AnimationController()
		{
			_content=new MinimalLowerThirds9(this);
		}
		private var texts:Array=[new GshahTextFont('JOHN DOE','Myriad Pro Regular',34,0xFFFFFF), new GshahTextFont('DESIGNER AND ANIMATOR','Myriad Pro Regular',20,0xFFFFFF)];
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
			return 421;
		}
		public function get contentWidth():Number
		{
			return 320;
		}
		public function get contentHeight():Number
		{
			return 78;
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