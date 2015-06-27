package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro10 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro10(c:IGshahOutroController=null) {
			controller=c as Outro10AnimationController;
		}
	}
	
}
