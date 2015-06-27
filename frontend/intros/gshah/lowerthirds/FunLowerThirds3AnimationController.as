package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.FunLowerThirds3;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class FunLowerThirds3AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function FunLowerThirds3AnimationController()
		{
			_content=new FunLowerThirds3(this);
		}
		private var texts:Array=[new GshahTextFont('Lorem ipsum dolor sit amet, est erat dissentiet id. Eirmod sententiae et nec, sed an cibo eloquentiam reprehendunt. Nec viris semper ad. At paulo tation per, natum primis sed ei. Mei ei dicit doctus, ei cum diam repudiare. Nam adipisci neglegentur ne, ad mei postea laboramus, alii sumo oportere et usu.\n Qui possim albucius ne. Te his idque facer saperet, ea cum oblique fastidii ullamcorper.','Myriad Pro Regular',16,0xFFFFFF), new GshahTextFont('www.yourcompany.com','Myriad Pro Bold',28,0xFFFFFF)];
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
			if(num>1)
			{
				num=1;
			}
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
			return -566;
		}
		public function get contentPaddingTop():Number
		{
			return 58;
		}
		public function get contentWidth():Number
		{
			return 1047;
		}
		public function get contentHeight():Number
		{
			return 272;
		}
		public function get numTexts():int
		{
			return 2;
		}
		public function get numLogos():int
		{
			return 1;
		}
	}
}