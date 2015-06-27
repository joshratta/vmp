package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SimpleLowerThirds3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SimpleLowerThirds3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SimpleLowerThirds3AnimationController()
		{
			_content=new SimpleLowerThirds3(this);
		}
		private var texts:Array=[new GshahTextFont('JOHN DOE Jr.','Myriad Pro Bold',50,0xFFFFFF), new GshahTextFont('ANIMATED LOWER THIRDS','Myriad Pro Bold',50,0xFFFFFF), new GshahTextFont('PRODUCED BY','Myriad Pro Regular',18,0xFFFFFF)];
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
			return -731;
		}
		public function get contentPaddingTop():Number
		{
			return 61;
		}
		public function get contentWidth():Number
		{
			return 732;
		}
		public function get contentHeight():Number
		{
			return 134;
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