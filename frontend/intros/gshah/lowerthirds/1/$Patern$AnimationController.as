﻿package gshah.lowerthirds
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import gshah.lowerthirds.$Patern$;
	import gshah.IGshahAnimationController;
	
	public class $Patern$AnimationController implements IGshahAnimationController
	{
		private var _content:MovieClip;
		public function $Patern$AnimationController()
		{
			_content=new $Patern$(this);
		}
		private var texts:Array=[$Texts$];
		public function setText(value:String, num:int):void
		{
			texts[num]=value;
			
			
		}
		private var logos:Array=[$Logos$];
		public function setLogo(value:Bitmap, num:int):void
		{
			logos[num]=value;
			
		}
		
		public function getText(num:int):String
		{
			return texts[num] as String;
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
			return $numTexts$;
		}
		public function get numLogos():int
		{
			return $numLogos$;
		}
	}
}