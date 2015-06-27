package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.GeometricLogo;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class GeometricLogoAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function GeometricLogoAnimationController()
		{
			_content=new GeometricLogo(this);
		}
		private var texts:Array=[new GshahTextFont('videomotionpro','Helvetica Light Regular',41,0x000000)];
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
			return 1;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}