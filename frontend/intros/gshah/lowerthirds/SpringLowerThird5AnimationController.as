﻿package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.SpringLowerThird5;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class SpringLowerThird5AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function SpringLowerThird5AnimationController()
		{
			_content=new SpringLowerThird5(this);
		}
		private var texts:Array=[];
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
			return 60;
		}
		public function get contentPaddingTop():Number
		{
			return 337;
		}
		public function get contentWidth():Number
		{
			return 203;
		}
		public function get contentHeight():Number
		{
			return 96;
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