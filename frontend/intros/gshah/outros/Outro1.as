package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro1 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro1(c:IGshahOutroController=null) {
			controller=c as Outro1AnimationController;
		}
	}
	
}
