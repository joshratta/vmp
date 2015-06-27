package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro6 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro6(c:IGshahOutroController=null) {
			controller=c as Outro6AnimationController;
		}
	}
	
}
