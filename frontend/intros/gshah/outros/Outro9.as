﻿package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro9 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro9(c:IGshahOutroController=null) {
			controller=c as Outro9AnimationController;
		}
	}
	
}
