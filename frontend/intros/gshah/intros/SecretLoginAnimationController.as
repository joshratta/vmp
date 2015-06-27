package gshah.intros
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.intros.SecretLogin;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SecretLoginAnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SecretLoginAnimationController()
		{
			_content=new SecretLogin(this);
		}
		private var texts:Array=[new GshahTextFont('SECRET ACCESS HERE','Myriad Pro Regular',24,0x272727), 
		new GshahTextFont('Admin_of_Your_Company','Myriad Pro Regular',26,0x666666), 
		new GshahTextFont('Loading..','Myriad Pro Italic',26,0xFFFFFF), 
		new GshahTextFont('www.yourcompany.com','Myriad Pro Regular',26,0xFFFFFF), 
		new GshahTextFont('Submit','Myriad Pro Regular',26,0xFFFFFF),
		new GshahTextFont('Username or email','Myriad Pro Italic',26,0xCCCCCC),
		new GshahTextFont('Password','Myriad Pro Italic',26,0xCCCCCC)];
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
			return 7;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}