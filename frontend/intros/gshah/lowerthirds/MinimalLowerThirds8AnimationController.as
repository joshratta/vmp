package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MinimalLowerThirds8;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MinimalLowerThirds8AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MinimalLowerThirds8AnimationController()
		{
			_content=new MinimalLowerThirds8(this);
		}
		private var texts:Array=[new GshahTextFont('Lorem ipsum dolor sit amet, est erat dissentiet id. Eirmod sententiae et nec, sed an cibo eloquentiam reprehendunt. Nec viris semper ad. At paulo tation per, natum primis sed ei. Mei ei dicit doctus, ei cum diam repudiare. Nam adipisci neglegentur ne, ad mei postea laboramus, alii sumo oportere et usu.\nQui possim albucius ne. Te his idque facer saperet, ea cum oblique fastidii ullamcorper.','Myriad Pro Regular',16,0xFFFFFF)];
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
			return 3;
		}
		public function get contentPaddingTop():Number
		{
			return 326;
		}
		public function get contentWidth():Number
		{
			return 952;
		}
		public function get contentHeight():Number
		{
			return 156;
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