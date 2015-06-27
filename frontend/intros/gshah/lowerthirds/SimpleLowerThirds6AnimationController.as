package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SimpleLowerThirds6;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;

	
	public class SimpleLowerThirds6AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SimpleLowerThirds6AnimationController()
		{
			_content=new SimpleLowerThirds6(this);
		}
		private var texts:Array=[new GshahTextFont('Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.','Myriad Pro Regular',20,0x000000)];
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
			return -190;
		}
		public function get contentPaddingTop():Number
		{
			return 0.;
		}
		public function get contentWidth():Number
		{
			return 381;
		}
		public function get contentHeight():Number
		{
			return 235;
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