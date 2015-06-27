package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro7 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro7(c:IGshahOutroController=null) {
			controller=c as Outro7AnimationController;
		}
	}
	
}
