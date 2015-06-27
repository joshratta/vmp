﻿package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.MotionBlock10;
	import gshah.IGshahAnimationController;
	import gshah.intros.texts.GshahTextFont;
	
	public class MotionBlock10AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function MotionBlock10AnimationController()
		{
			_content=new MotionBlock10(this);
		}
		private var texts:Array=[''];
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
			return -418;
		}
		public function get contentPaddingTop():Number
		{
			return 70;
		}
		public function get contentWidth():Number
		{
			return 419;
		}
		public function get contentHeight():Number
		{
			return 99;
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