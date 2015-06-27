package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SimpleLowerThirds5;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SimpleLowerThirds5AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SimpleLowerThirds5AnimationController()
		{
			_content=new SimpleLowerThirds5(this);
		}
		private var texts:Array=[new GshahTextFont('SINGLE TEXT','Myriad Pro Regular',50,0xFFFFFF)];
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
			return -725;
		}
		public function get contentPaddingTop():Number
		{
			return 128;
		}
		public function get contentWidth():Number
		{
			return 726;
		}
		public function get contentHeight():Number
		{
			return 67;
		}
		public function get numTexts():int
		{
			return 1;
		}
		public function get numLogos():int
		{
			return 0;
		}
	}
}