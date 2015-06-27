package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro4 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro4(c:IGshahOutroController=null) {
			controller=c as Outro4AnimationController;
		}
	}
	
}
